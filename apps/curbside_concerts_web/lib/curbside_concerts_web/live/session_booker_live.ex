defmodule CurbsideConcertsWeb.SessionBookerLive do
  @moduledoc """
  Live view for the Session Booking; adding requests to sessions.
  """
  use CurbsideConcertsWeb, :live_view

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.RequestView

  def mount(%{"session_id" => session_id} = _params, _session, socket) do
    unbooked_requests = Requests.all_unbooked_requests()

    session = Musicians.find_session(session_id)

    socket =
      socket
      |> assign(:unbooked_requests, unbooked_requests)
      |> assign(:session, session)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="booker">
      <div class="column">
        <h2>Unbooked Requests</h2>

        <%= for request <- @unbooked_requests do %>
          <%= render_request_card(assigns, request) %>
        <% end %>
        <%= if @unbooked_requests == [] do %>
          <div class="card">
            There are no unbooked requests.
          </div>
        <% end %>
      </div>

      <div class="column">
        <h2>Requests in Session: <%= @session.name %></h2>

        <%= unless @session.requests == [] do %>
          <%= RequestView.map_route_link(@session.requests) %>
        <% end %>
        <%= for request <- @session.requests do %>
          <%= render_request_card(assigns, request) %>
        <% end %>
        <%= if @session.requests == [] do %>
          <div class="card">
            There are no requests in this session yet.
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp render_request_card(assigns, %Request{
         nominee_address: nominee_address,
         special_message: special_message
       }) do
    ~L"""
    <div class="card">
      <b>Address:</b> <%= nominee_address %><br>
      <b>Genre:</b> ???<br>
      <b>Special Message:</b> <%= special_message %><br>
    </div>
    """
  end
end
