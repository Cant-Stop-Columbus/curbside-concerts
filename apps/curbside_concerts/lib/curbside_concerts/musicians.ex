defmodule CurbsideConcerts.Musicians do
  import Ecto.Query, warn: false

  alias CurbsideConcerts.Repo
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session

  use EctoResource

  using_repo(Repo) do
    resource(Musician, only: [:all, :change])
    resource(Session, only: [:change, :create, :update])
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
  def all_sessions do
    Session
    |> preload([:musician])
    |> Repo.all()
  end

  def all_upcoming_sessions do
    now = DateTime.now!("America/New_York")

    Session
    |> where([s], is_nil(s.start_time) or s.start_time >= ^now)
    |> Repo.all()
  end

  def find_session(session_id) do
    Session
    |> where([s], s.id == ^session_id)
    |> preload([:musician])
    |> Repo.one()
  end
end
