defmodule CurbsideConcertsWeb.SessionView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.RequestView
  alias CurbsideConcertsWeb.Helpers.RequestAddress

  def musician_options(musicians) do
    Enum.map(musicians, fn %Musician{id: id, name: name} ->
      {name, id}
    end)
  end

  def driver_musician_links(%Session{id: session_id}) do
    session_id = CurbsideConcertsWeb.TrackerCypher.encode(session_id)

    ~E"""
    <%= link "Driver Link", to: Routes.session_route_driver_path(CurbsideConcertsWeb.Endpoint, CurbsideConcertsWeb.DriverLive, session_id) %>
    | <%= link "Musician Link", to: Routes.session_path(CurbsideConcertsWeb.Endpoint, :session_route_artist, session_id) %>
    """
  end
end
