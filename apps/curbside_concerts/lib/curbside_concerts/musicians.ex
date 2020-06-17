defmodule CurbsideConcerts.Musicians do
  import Ecto.Query, warn: false

  alias CurbsideConcerts.Repo
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests.Request

  use EctoResource

  using_repo(Repo) do
    resource(Musician, only: [:all, :change, :get, :update])
    resource(Session, only: [:change, :create, :get, :update])
    resource(Genre, only: [:all, :change, :create, :get, :update])
  end

  ### Musicians

  def create_musician(attrs \\ %{}) do
    %Musician{}
    |> Musician.changeset(attrs)
    |> Repo.insert()
  end

  def find_musician_by_gigs_id(gigs_id) do
    Repo.one(from m in Musician, where: m.gigs_id == ^gigs_id)
  end

  ### Sessions
  def all_sessions(queryable) do
    queryable
    |> preload_session()
    |> Repo.all()
  end

  def all_active_sessions do
    Session
    |> where([s], s.archived == false)
    |> all_sessions()
  end

  def all_archived_sessions do
    Session
    |> where([s], s.archived == true)
    |> all_sessions()
  end

  def all_upcoming_sessions do
    {:ok, now} = DateTime.now("America/New_York")

    Session
    |> where([s], is_nil(s.start_time) or s.start_time >= ^now)
    |> preload_session()
    |> Repo.all()
  end

  def all_sessions_and_requests do
    Session
    |> preload([:requests])
    |> Repo.all()
  end

  def find_session(session_id) do
    Session
    |> where([s], s.id == ^session_id)
    |> preload_session()
    |> Repo.one()
  end

  defp preload_session(query) do
    requests_query = from(r in Request, order_by: r.rank, preload: [:genres])
    preload(query, [:musician, requests: ^requests_query])
  end

  def archive_session(session) do
    update_session(session, %{
      archived: true
    })
  end

  def unarchive_session(session) do
    update_session(session, %{
      archived: false
    })
  end

  ### Genres
  def all_active_genres() do
    Genre
    |> where([g], g.archived == false)
    |> Repo.all()
  end

  def all_archived_genres() do
    Genre
    |> where([g], g.archived == true)
    |> Repo.all()
  end

  def get_genres_by_ids(nil), do: []

  def get_genres_by_ids(ids) do
    Repo.all(from g in Genre, where: g.id in ^ids)
  end

  def archive_genre(genre) do
    update_genre(genre, %{
      archived: true
    })
  end

  def unarchive_genre(genre) do
    update_genre(genre, %{
      archived: false
    })
  end
end
