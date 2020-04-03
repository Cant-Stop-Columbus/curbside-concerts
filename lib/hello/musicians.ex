defmodule Hello.Musicians do
  alias Hello.Repo
  alias Hello.Musicians.Musician

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
end
