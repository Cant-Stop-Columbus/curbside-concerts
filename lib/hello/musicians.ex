defmodule Hello.Musicians do
  import Ecto.Query, warn: false

  alias Hello.Repo
  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  def change_musician(%Musician{} = musician) do
    Musician.changeset(musician, %{})
  end

  def create_musician(attrs \\ %{}) do
    attrs = format_playlist(attrs)

    %Musician{}
    |> Musician.changeset(attrs)
    |> Repo.insert()
  end

  def all do
    Repo.all(Musician)
  end

  defp format_playlist(attrs) do
    if is_binary(attrs["playlist"]) do
      playlist = String.split(attrs["playlist"], "|")
      Map.put(attrs, "playlist", playlist)
    else
      attrs
    end
  end

  ### SESSIONS

  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def all_sessions do
    Session
    |> preload([:musician])
    |> Repo.all()
  end
end
