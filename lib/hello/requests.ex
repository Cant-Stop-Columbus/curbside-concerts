defmodule Hello.Requests do
  @moduledoc """
  Requests start in a pending state.

  They can be moved along the flow of:
  pending > accepted > enroute > arrived > completed

  They can also be moved to the following states at any time:
    * pending
    * canceled
    * archived
  """

  @pending "pending"
  @accepted "accepted"
  @enroute "enroute"
  @arrived "arrived"
  @completed "completed"
  @canceled "canceled"
  @archived "archived"

  @valid_states [@pending, @accepted, @enroute, @arrived, @completed, @canceled, @archived]

  use Machinery,
    field: :state,
    # If any request in a session is enroute, the entire session is started.
    states: @valid_states,
    transitions: %{
      @pending => @accepted,
      @accepted => @enroute,
      @enroute => @arrived,
      @arrived => @completed,
      "*" => [@pending, @canceled, @archived]
    }

  import Ecto.Query

  alias Hello.Repo
  alias Hello.Requests.Request
  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  use EctoResource

  using_repo(Repo) do
    resource(Request, only: [:all, :change, :create])
  end

  def accept_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @accepted)
  end

  def enroute_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @enroute)
  end

  def cancel_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @canceled)
  end

  def arrived_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @arrived)
  end

  def complete_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @completed)
  end

  def archive_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @archived)
  end

  def back_to_pending_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @pending)
  end

  @doc """
  Gets called automatically following a Machinery.transition_to/3 call.
  """
  def persist(%Request{} = request, next_state) do
    {:ok, request} = __MODULE__.update_request(request, %{state: next_state})
    request
  end

  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  def find_request(request_id) do
    Request
    |> where([r], r.id == ^request_id)
    |> Repo.one()
  end

  def all do
    Request
    |> preload(session: :musician)
    |> Repo.all()
  end

  def get_by_gigs_id(gigs_id) do
    query =
      from(
        request in Request,
        join: session in Session,
        join: musician in Musician,
        on:
          request.session_id == session.id and
            session.musician_id == musician.id,
        where: musician.gigs_id == ^gigs_id
      )
      |> preload(session: :musician)

    Repo.all(query)
  end
end
