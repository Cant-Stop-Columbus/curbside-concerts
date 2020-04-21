defmodule CurbsideConcertsWeb.DriverLive do
  @moduledoc """
  Live view for the Driver page. Allows driver to move requests along its state flow.
  """
  use CurbsideConcertsWeb, :live_view

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.Helpers.RequestAddress
  alias CurbsideConcertsWeb.RequestView
  alias CurbsideConcertsWeb.TrackerCypher

  def mount(%{"driver_id" => driver_id} = _params, _session, socket) do
    session_id = TrackerCypher.decode(driver_id)
    {:ok, reload_session(session_id, socket)}
  end

  # def enroute_state, do: @enroute
  # def arrived_state, do: @arrived
  # def completed_state, do: @completed
  def handle_event("make_enroute", %{"request_id" => request_id}, socket) do
    request = Requests.find_request(request_id)
    Requests.enroute_request(request)

    {:noreply, reload_session(socket)}
  end

  def handle_event("make_enroute", params, socket) do
    IO.inspect(params, label: "event params")
    {:noreply, socket}
  end

  def handle_event("make_arrived", %{"request_id" => request_id}, socket) do
    request = Requests.find_request(request_id)
    Requests.arrived_request(request)

    {:noreply, reload_session(socket)}
  end

  def handle_event("make_completed", %{"request_id" => request_id}, socket) do
    request = Requests.find_request(request_id)
    Requests.complete_request(request)

    {:noreply, reload_session(socket)}
  end

  def render(assigns) do
    ~L"""
    <h2>Driver for <%= @session.name %></h2>
    <%= RequestView.map_route_link(@requests) %>

    <%= for request <- @requests do %>
      <%= render_request(assigns, request) %>
    <% end %>
    """
  end

  def render_request(
        assigns,
        %Request{
          nominee_name: nominee_name,
          nominee_phone: nominee_phone,
          nominee_address_notes: nominee_address_notes,
          requester_name: requester_name,
          requester_phone: requester_phone,
          requester_email: requester_email,
          special_message: special_message,
          genres: genres
        } = request
      ) do
    ~L"""
    <div class="card">
      <%= render_request_state_button(assigns, request) %>

      <div><b>Contact Preference:</b> <%= RequestView.contact_preference(request) %></div>

      <br>

      <div>
        <b>Map to <%= nominee_name %>'s house:</b>
        <a href="http://maps.google.com/?q=<%= URI.encode(RequestAddress.full_address(request)) %>"><%= RequestAddress.full_address(request) %></a>
      </div>

      <%= if nominee_address_notes do %>
        <div>
          <b>Address Instructions:</b> <%= raw nominee_address_notes %>
        </div>
      <% end %>

      <br>

      <div style="display: flex">
        <div style="margin-right: 16px">
          <b>To:</b><br>
          <%= nominee_name %><br>
          <%= nominee_phone %>
        </div>
        <div>
          <b>From:</b><br>
          <%= requester_name %><br>
          <%= requester_phone %><br>
          <%= requester_email %>
        </div>
      </div>
      <div>
        <div>
          <b>Preferred Genres:</b>
          <ul>
            <%= for %Genre{name: name} <- genres do %>
              <li><%= name %></li>
            <% end %>
          </ul>
        </div>
        <div><b>Special Message:</b><br>
          <%= special_message %>
        </div>
      </div>
    </div>
    """
  end

  def render_request_state_button(assigns, request) do
    ~L"""
    <div>
      <b><%= RequestView.display_state(request) %></b>
      <%= render_call_to_action(assigns, request) %>
    </div>
    """
  end

  def render_call_to_action(assigns, request) do
    accepted_state = Requests.accepted_state()
    enroute_state = Requests.enroute_state()
    arrived_state = Requests.arrived_state()

    case request.state do
      ^accepted_state ->
        ~L|<button phx-click="make_enroute" phx-value-request_id="<%= request.id %>">Heading There Now</button>|

      ^enroute_state ->
        ~L|<button phx-click="make_arrived" phx-value-request_id="<%= request.id %>">We Have Arrived</button>|

      ^arrived_state ->
        ~L|<button phx-click="make_completed" phx-value-request_id="<%= request.id %>">Concert Completed</button>|

      _ ->
        nil
    end
  end

  defp reload_session(%{assigns: %{session_id: session_id}} = socket) do
    reload_session(session_id, socket)
  end

  defp reload_session(session_id, socket) do
    session = Musicians.find_session(session_id)

    assign(socket, %{
      session_id: session_id,
      session: session,
      requests: session.requests
    })
  end
end
