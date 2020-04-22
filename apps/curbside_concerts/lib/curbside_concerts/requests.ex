defmodule CurbsideConcerts.Requests do
  @moduledoc """
  Requests start in a pending state.

  They can be moved along the flow of:
  pending > accepted > enroute > arrived > completed

  They can also be moved to the following states at any time:
    * pending
    * canceled
    * offmission
  """

  @pending "pending"
  @accepted "accepted"
  @enroute "enroute"
  @arrived "arrived"
  @completed "completed"
  @canceled "canceled"
  @offmission "offmission"

  @valid_states [@pending, @accepted, @enroute, @arrived, @completed, @canceled, @offmission]

  use Machinery,
    field: :state,
    # If any request in a session is enroute, the entire session is started.
    states: @valid_states,
    transitions: %{
      @pending => @accepted,
      @accepted => @enroute,
      @enroute => @arrived,
      @arrived => @completed,
      "*" => [@pending, @canceled, @offmission]
    }

  import Ecto.Query

  alias CurbsideConcerts.Repo
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session

  use EctoResource

  using_repo(Repo) do
    resource(Request, only: [:all, :change, :get, :update])
  end

  def pending_state, do: @pending

  def accepted_state, do: @accepted

  def enroute_state, do: @enroute

  def arrived_state, do: @arrived

  def completed_state, do: @completed

  def canceled_state, do: @canceled

  def offmission_state, do: @offmission

  def accept_requests(list) when is_list(list) do
    Enum.each(list, &accept_request/1)
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

  def back_to_pending_requests(list) when is_list(list) do
    Enum.each(list, &back_to_pending_request/1)
  end

  def back_to_pending_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @pending)
  end

  def off_mission_request(%Request{} = request) do
    Machinery.transition_to(request, __MODULE__, @offmission)
  end

  @doc """
  Gets called automatically following a Machinery.transition_to/3 call.
  """
  def persist(%Request{} = request, next_state) do
    {:ok, request} = __MODULE__.update_request(request, %{state: next_state})
    request
  end

  def create_request(attrs) do
    %Request{}
    |> Request.changeset(attrs)
    |> put_assoc_genres(attrs)
    |> Repo.insert()
  end

  def archive_request(request) do
    __MODULE__.update_request(request, %{
      archived: true
    })
  end

  def find_request(request_id) do
    Request
    |> where([r], r.id == ^request_id)
    |> preload([:genres, [session: :musician]])
    |> Repo.one()
  end

  def find_request_with_children(request_id) do
    Request
    |> where([r], r.id == ^request_id)
    |> preload([{:session, :musician}, :genres])
    |> Repo.one()
  end

  def all_active_requests_by_state(state) do
    Request
    |> where([s], s.archived == false and s.state == ^state)
    |> preload([:session, :genres])
    |> Repo.all()
  end

  def all_active_requests do
    Request
    |> where([r], r.archived == false)
    |> preload([:session, :genres])
    |> Repo.all()
  end

  def all_ranked_requests do
    Request
    |> preload([:session, :genres])
    |> order_by(:rank)
    |> Repo.all()
  end

  def all_last_minute_requests do
    Request
    |> where([r], is_nil(r.session_id) and r.state == ^@pending and r.archived == false)
    |> preload([:genres])
    |> order_by({:desc, :inserted_at})
    |> Repo.all()
  end

  def all_unbooked_requests do
    Request
    |> where([r], is_nil(r.session_id) and r.state == ^@pending and r.archived == false)
    |> preload([:genres])
    |> order_by(:rank)
    |> Repo.all()
  end

  def all_archived_requests do
    Request
    |> where([r], r.archived == true)
    |> preload([:genres])
    |> order_by({:desc, :updated_at})
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
      |> preload([:session, :genres])
      |> order_by(:rank)

    Repo.all(query)
  end

  def load_genres(request), do: Repo.preload(request, :genres)

  defp put_assoc_genres(changeset, []), do: changeset

  defp put_assoc_genres(changeset, attrs) do
    genres = Musicians.get_genres_by_ids(attrs["genres"])
    Ecto.Changeset.put_assoc(changeset, :genres, genres)
  end
end
