defmodule Hello.Requests do
  import Ecto.Query

  alias Hello.Repo
  alias Hello.Requests.Request
  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  use EctoResource

  using_repo(Repo) do
    resource(Request, only: [:all, :change, :create])
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
