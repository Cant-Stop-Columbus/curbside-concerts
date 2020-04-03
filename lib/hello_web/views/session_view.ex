defmodule HelloWeb.SessionView do
  use HelloWeb, :view

  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  def musician_options(musicians) do
    Enum.map(musicians, fn %Musician{id: id, name: name} ->
      {name, id}
    end)
  end
end
