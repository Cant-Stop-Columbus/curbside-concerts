defmodule CurbsideConcerts.Musicians do
  import Ecto.Query, warn: false

  alias CurbsideConcerts.Repo
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session

  use EctoResource

  using_repo(Repo) do
    resource(Musician, only: [:all, :change])
    resource(Session, only: [:change, :create, :get, :update])
    resource(Genre, only: [:all, :change, :create, :get, :update])
  end

  ### Musicians

  def create_musician(attrs \\ %{}) do
    attrs = format_playlist(attrs)

    %Musician{}
    |> Musician.changeset(attrs)
    |> Repo.insert()
  end

  def find_musician_by_gigs_id(gigs_id) do
    Repo.one(from m in Musician, where: m.gigs_id == ^gigs_id)
  end

  defp format_playlist(attrs) do
    if is_binary(attrs["playlist"]) do
      playlist = String.split(attrs["playlist"], "|")
      Map.put(attrs, "playlist", playlist)
    else
      attrs
    end
  end

  ### Sessions
  def all_sessions(queryable) do
    queryable
    |> preload([:musician])
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
    |> Repo.all()
  end

  def find_session(session_id) do
    Session
    |> where([s], s.id == ^session_id)
    |> preload([:musician, :requests])
    |> Repo.one()
  end

  def archive_session(session) do
    update_session(session, %{
      archived: true
    })
  end

  ### Genres
  def get_genres_by_ids(nil), do: []

  def get_genres_by_ids(ids) do
    Repo.all(from g in Genre, where: g.id in ^ids)
  end
end
