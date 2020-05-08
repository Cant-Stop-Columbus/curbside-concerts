defmodule CurbsideConcertsWeb.SessionView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests
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

  def session_status(%Session{requests: requests}) do
    states = Enum.map(requests, fn %Request{state: state} ->
      state
    end)
    in_progress_states = [Requests.enroute_state(), Requests.arrived_state(), Requests.completed_state()]
    done_states = [Requests.completed_state(), Requests.canceled_state()]

    cond do
      Enum.all?(states, fn state -> state == Requests.pending_state() end) -> "Draft"
      Enum.any?(states, fn state -> state == Requests.pending_state() end) -> "Draft (inconsistent states)"
      Enum.all?(states, fn state -> state == Requests.accepted_state() end) -> "Finalized"
      Enum.all?(states, fn state -> Enum.member?(done_states, state) end) -> "Completed"
      Enum.any?(states, fn state -> Enum.member?(in_progress_states, state) end) -> "Finalized"
      true -> "Something weird happened"
    end
  end
end
