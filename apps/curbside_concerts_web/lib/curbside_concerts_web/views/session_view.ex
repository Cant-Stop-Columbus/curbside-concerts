defmodule CurbsideConcertsWeb.SessionView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.RequestView

  def musician_options(musicians) do
    Enum.map(musicians, fn %Musician{id: id, name: name} ->
      {name, id}
    end)
  end
end
