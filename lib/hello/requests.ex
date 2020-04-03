defmodule Hello.Requests do
  import Ecto.Query

  alias Hello.Repo
  alias Hello.Requests.Request
  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end

  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(Request)
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

    Repo.all(query)
  end
end
