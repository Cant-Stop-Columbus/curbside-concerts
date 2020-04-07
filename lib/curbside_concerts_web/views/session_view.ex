defmodule CurbsideConcertsWeb.SessionView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session

  def musician_options(musicians) do
    Enum.map(musicians, fn %Musician{id: id, name: name} ->
      {name, id}
    end)
  end
end
