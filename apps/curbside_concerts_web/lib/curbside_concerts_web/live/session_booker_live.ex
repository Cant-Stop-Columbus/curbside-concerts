defmodule CurbsideConcertsWeb.SessionBookerLive do
  @moduledoc """
  Live view for the Session Booking; adding requests to sessions.
  """
  use CurbsideConcertsWeb, :live_view

  alias CurbsideConcerts.LexoRanker
  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.RequestView
  alias CurbsideConcertsWeb.Helpers.RequestAddress
  alias CurbsideConcertsWeb.ZipCodeSessionScorer
  alias CurbsideConcertsWeb.EmailRequest

  def mount(%{"session_id" => session_id} = _params, _session, socket) do
    unbooked_requests = Requests.all_unbooked_requests()
    session = Musicians.find_session(session_id)

    # PubSub turned off for now
    # CurbsideConcertsWeb.Endpoint.subscribe("session:#{session_id}")
    # CurbsideConcertsWeb.Endpoint.subscribe("unbooked")

    socket =
      socket
      |> assign(:unbooked_requests, unbooked_requests)
      |> assign(:session_requests, session.requests)
      |> assign(:session, session)
      |> assign(:sort_by, nil)
      |> assign(:genre_filter, nil)
      |> assign(:show_full_request, false)
      |> assign(:saved, false)
      |> assign(:saved_as_draft, false)
      |> assign(:saved_as_final, false)

    {:ok, socket}
  end

  def handle_event(
        "save_as_draft",
        _params,
        %{
          assigns: %{
            session: %Session{id: session_id},
            unbooked_requests: unbooked_requests,
            session_requests: session_requests
          }
        } = socket
      ) do
    Enum.reduce(unbooked_requests, nil, fn request, last_rank ->
      last_rank = LexoRanker.calculate(last_rank, nil)
      Requests.update_request(request, %{rank: last_rank, session_id: nil, session: nil})
      last_rank
    end)

    Enum.reduce(session_requests, nil, fn request, last_rank ->
      last_rank = LexoRanker.calculate(last_rank, nil)
      Requests.update_request(request, %{rank: last_rank, session_id: session_id})
      if(request.session_id == nil) do
        Task.start(fn -> EmailRequest.send_session_booked(request.id) end)
      end
      last_rank
    end)

    unbooked_requests = Requests.all_unbooked_requests()
    session = Musicians.find_session(session_id)

    {:noreply,
     assign(socket,
       saved_as_draft: true,
       saved_as_final: false,
       unbooked_requests: unbooked_requests,
       session_requests: session.requests,
       session: session
     )}
  end

  def handle_event(
        "save_as_final",
        _params,
        %{
          assigns: %{
            session: %Session{id: session_id},
            unbooked_requests: unbooked_requests,
            session_requests: session_requests
          }
        } = socket
      ) do
    Requests.back_to_pending_requests(unbooked_requests)
    Requests.accept_requests(session_requests)

    unbooked_requests = Requests.all_unbooked_requests()
    session = Musicians.find_session(session_id)

    {:noreply,
     assign(socket,
       saved_as_draft: false,
       saved_as_final: true,
       unbooked_requests: unbooked_requests,
       session_requests: session.requests,
       session: session
     )}
  end

  def handle_event(
        "priority_toggle",
        %{
          "request_id" => request_id,
          "toggle_to" => toggle_to
        },
        %{assigns: %{unbooked_requests: unbooked_requests, session_requests: session_requests}} =
          socket
      ) do
    IO.inspect({request_id, toggle_to}, label: "priority_toggle")
    priority? = toggle_to == "on"

    request_id
    |> Requests.find_request()
    |> Requests.update_request(%{priority: priority?})

    unbooked_requests = adjust_priority(unbooked_requests, request_id, priority?)
    session_requests = adjust_priority(session_requests, request_id, priority?)

    {:noreply,
     assign(socket, %{
       unbooked_requests: unbooked_requests,
       session_requests: session_requests
     })}
  end

  def handle_event(
        "move_request",
        %{
          "request_id" => request_id,
          "over_request_id" => over_request_id,
          "from_session_id" => from_session_id,
          "to_session_id" => to_session_id
        },
        %{assigns: %{unbooked_requests: unbooked_requests, session_requests: session_requests}} =
          socket
      ) do
    booked? = !is_nil(to_session_id)
    internal_move? = from_session_id == to_session_id

    {unbooked_requests, session_requests} =
      if booked? do
        if internal_move? do
          session_requests = internal_move_request(request_id, over_request_id, session_requests)
          {unbooked_requests, session_requests}
        else
          move_request(request_id, over_request_id, unbooked_requests, session_requests)
        end
      else
        if internal_move? do
          unbooked_requests =
            internal_move_request(request_id, over_request_id, unbooked_requests)

          {unbooked_requests, session_requests}
        else
          {session_requests, unbooked_requests} =
            move_request(request_id, over_request_id, session_requests, unbooked_requests)

          {unbooked_requests, session_requests}
        end
      end

    # Turned of PubSub for now
    # CurbsideConcertsWeb.Endpoint.broadcast_from(
    #   self(),
    #   "request_booking:#{session_id}",
    #   "message",
    #   %{
    #     session: session_id
    #   }
    # )

    {:noreply,
     assign(socket,
       unbooked_requests: unbooked_requests,
       session_requests: session_requests,
       saved_as_draft: false,
       saved_as_final: false
     )}
  end

  def handle_event("update-filters", params, socket) do
    socket =
      assign(socket, %{
        sort_by: Map.get(params, "sort_by"),
        genre_filter: Map.get(params, "genre_filter"),
        show_full_request: Map.get(params, "show_full_request")
      })

    {:noreply, socket}
  end

  defp internal_move_request(request_id, over_request_id, list) do
    request =
      Enum.find(list, fn %Request{id: id} ->
        "#{request_id}" == "#{id}"
      end)

    over_request =
      Enum.find(list, fn %Request{id: id} ->
        "#{over_request_id}" == "#{id}"
      end)

    list = List.delete(list, request)

    if over_request do
      over_request_index =
        Enum.find_index(list, fn %Request{id: id} ->
          "#{over_request_id}" == "#{id}"
        end)

      List.insert_at(list, over_request_index, request)
    else
      list ++ [request]
    end
  end

  defp move_request(request_id, over_request_id, from_list, to_list) do
    request =
      Enum.find(from_list, fn %Request{id: id} ->
        "#{request_id}" == "#{id}"
      end)

    over_request =
      Enum.find(to_list, fn %Request{id: id} ->
        "#{over_request_id}" == "#{id}"
      end)

    from_list = List.delete(from_list, request)
    to_list = List.delete(to_list, request)

    to_list =
      if over_request do
        over_request_index =
          Enum.find_index(to_list, fn %Request{id: id} ->
            "#{over_request_id}" == "#{id}"
          end)

        List.insert_at(to_list, over_request_index, request)
      else
        to_list ++ [request]
      end

    {from_list, to_list}
  end

  # def handle_info(
  #       %{event: "message", payload: %{session: session_id}},
  #       %{assigns: %{logs: logs}} = socket
  #     ) do
  #   {:noreply,
  #    assign(socket,
  #      #  unbooked_requests: unbooked_requests,
  #      logs: ["Them: Booking #{session_id}" | logs]
  #    )}
  # end

  def render(assigns) do
    filtered_requests = apply_filters(assigns, assigns[:unbooked_requests])
    filtered_length = length(filtered_requests)
    unbooked_length = length(assigns[:unbooked_requests])

    ~L"""
    <div class="booker">
      <div class="card">
        Drag and drop requests. <br>
        <%= if @saved_as_draft do %>
          <button phx-click="save_as_final">Make final</button> to mark sessions as Booked.
        <% end %>
        <%= unless @saved_as_draft or @saved_as_final do %>
          <button phx-click="save_as_draft">Save as Draft</button> to remember your changes.<br>
        <% end %>

        <%= if @saved_as_draft do %>
          <br><br>Saved as draft!
        <% end %>
        <%= if @saved_as_final do %>
          <br><br>Saved as final!
        <% end %>
        <br>
        <b>Legend:</b>
        <br><span class="priority-toggle priority-off"></span>Priority OFF
          <span class="priority-toggle priority-on"></span>Priority ON (clickable)
        <br><span class="days-ago-badge"><div class="days-text">8</div></span> request days old
        <br><span class="badge good">70</span> based on the requests' ZIP codes and how close they are to the locations on the route booked so far, including the truck pickup location.
      </div>
      <div class="columns">
        <div class="column">
          <% length = if filtered_length == unbooked_length, do: unbooked_length, else: "#{filtered_length} filtered from #{unbooked_length}" %>
          <h2>Unbooked Requests (<%= length %>)</h2>
          <%= render_filters(assigns) %>

          <div class="scrollable">
            <%= for request <- filtered_requests do %>
              <%= render_request_card(assigns, request, @session_requests) %>
            <% end %>
            <%= if filtered_requests == [] do %>
              <div class="card">
                There are no unbooked requests.
              </div>
            <% end %>
          </div>
        </div>

        <div class="column" phx-value-session-id="<%= @session.id %>">
          <h2>Requests in Session: <%= @session.name %></h2>

          <%= unless @session_requests == [] do %>
            <%= RequestView.map_route_link(@session_requests) %>
          <% end %>
          <div class="scrollable">
            <%= for request <- @session_requests do %>
              <%= render_request_card(assigns, request, @session_requests) %>
            <% end %>
            <%= if @session_requests == [] do %>
              <div class="card">
                There are no requests in this session yet.
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp render_filters(assigns) do
    genres =
      (assigns[:unbooked_requests] ++ assigns[:session_requests])
      |> Enum.flat_map(fn request ->
        Enum.map(request.genres, fn %Genre{id: genre_id, name: genre_name} ->
          {genre_id, genre_name}
        end)
      end)
      |> Enum.uniq()
      |> Enum.sort_by(&elem(&1, 1))

    assigns = Map.put(assigns, :genres, genres)

    ~L"""
    <form phx-change="update-filters">
    Sort by:
      <%= render_sorts(assigns) %>
    <br>Filter by:
      <%= render_genre_filter(assigns) %>
    <br>
      <%= render_show_amount(assigns) %>
    </form>
    """
  end

  defp render_sorts(assigns) do
    ~E"""
    <select name="sort_by">
      <option value="" <%= if !@sort_by or @sort_by == "", do: "selected" %>>No Sort Applied</option>
      <option value="special_day_first" <%= if @sort_by == "special_day_first", do: "selected" %>>Special Day First</option>
      <option value="priority_first" <%= if @sort_by == "priority_first", do: "selected" %>>Priority First</option>
      <option value="oldest_first" <%= if @sort_by == "oldest_first", do: "selected" %>>Oldest First</option>
      <option value="newest_first" <%= if @sort_by == "newest_first", do: "selected" %>>Newest First</option>
    </select>
    """
  end

  defp render_genre_filter(assigns) do
    ~L"""
    <select name="genre_filter">
      <option value="" <%= if !@genre_filter or @genre_filter == "", do: "selected" %>>All Genres</option>
      <%= for {genre_id, genre_name} <- @genres do %>
        <option value="<%= genre_id %>" <%= if @genre_filter == "#{genre_id}", do: "selected" %>><%= genre_name %></option>
      <% end %>
    </select>
    """
  end

  defp render_show_amount(assigns) do
    ~E"""
    <label>
      <input type="checkbox" name="show_full_request" value="true" <%= if @show_full_request == "true", do: "checked" %>/>
      Show full request
    </label>
    """
  end

  defp apply_filters(%{sort_by: sort_by, genre_filter: genre_filter} = _assigns, requests) do
    requests
    |> apply_filter("sort_by", sort_by)
    |> apply_filter("genre_filter", genre_filter)
  end

  defp apply_filter(requests, "sort_by", sort_by) do
    case sort_by do
      "special_day_first" ->
        Enum.sort_by(
          requests,
          fn %Request{preferred_date: preferred_date} -> "#{preferred_date}" end,
          &>/2
        )

      "priority_first" ->
        Enum.sort_by(requests, fn %Request{priority: priority?} -> priority? end, &>/2)

      "oldest_first" ->
        Enum.sort_by(requests, fn %Request{inserted_at: inserted_at} -> inserted_at end)

      "newest_first" ->
        Enum.sort_by(requests, fn %Request{inserted_at: inserted_at} -> inserted_at end, &>/2)

      _ ->
        requests
    end
  end

  defp apply_filter(requests, "genre_filter", genre_id)
       when is_binary(genre_id) and genre_id != "" do
    requests
    |> Enum.filter(fn %Request{genres: genres} ->
      Enum.any?(genres, fn %Genre{id: id} -> "#{id}" == genre_id end)
    end)
  end

  defp apply_filter(requests, _, _), do: requests

  defp render_request_card(
         assigns,
         %Request{
           id: request_id,
           priority: priority?,
           special_message: special_message,
           request_reason: request_reason,
           nominee_address_notes: address_notes,
           special_instructions: special_instructions
         } = request,
         comparing_requests
       ) do
    # request_reason
    # nominee_description
    # special_message_sender_name
    # nominee_favorite_music_notes
    # request_occasion
    # nominee_email
    # requester_relationship
    # special_instructions

    ~L"""
    <div phx-hook="RequestBookerCard"
         phx-value-request-id="<%= request_id %>"
         class="draggable-card"
         ondblclick="window.open('<%= Routes.request_path(CurbsideConcertsWeb.Endpoint, :show, request) %>', 'request_view')"
         draggable="true">
      <div class="card <%= if priority?, do: "priority-request" %>">
        <div class="card-quick-stats">
          <%= if request.preferred_date do %>
            <b>Special Day: </b><%= request.preferred_date %> &nbsp;
          <% end %>
          <%= if priority? do %>
            <div class="priority-toggle priority-on" phx-click="priority_toggle" phx-value-toggle_to="off" phx-value-request_id="<%= request_id %>"></div>
          <% else %>
            <div class="priority-toggle priority-off" phx-click="priority_toggle" phx-value-toggle_to="on" phx-value-request_id="<%= request_id %>"></div>
          <% end %>
          <%= RequestView.days_ago_badge(request) %>
          <%= zip_score(assigns, request, comparing_requests) %>
        </div>
        <b>Address:</b> <%= RequestAddress.full_address(request) %>
        <%= if @show_full_request do %>
          <br><%= address_notes %>
        <% end %>
        <br><b>Genres:</b> <%= Enum.map(request.genres, fn g -> g.name end) |> Enum.join(", ") %><br>
        <%= if request_reason do %>
          <b>Request Reason:</b> <%= request_reason %> <br>
        <% end %>
        <b>Special Message:</b> <%= special_message %><br>
        <%= if special_instructions do %>
          <b>Special Instructions:</b> <%= special_instructions %><br>
        <% end %>
        <%= if @show_full_request == "true" do %>
          <b>Contact Pref:</b> <%= request.contact_preference %><br>
          <b>Nominee:</b> <%= request.nominee_name %><br>
          <b>Nominee Phone:</b> <%= request.nominee_phone %><br>
          <b>Requester:</b> <%= request.requester_name %><br>
          <b>Requester Phone:</b> <%= request.requester_phone %><br>
          <b>Requester Email:</b> <%= request.requester_email %><br>
        <% end %>
      </div>
    </div>
    """
  end

  defp zip_score(assigns, request, comparing_requests) do
    other_zips = ["43215" | Enum.map(comparing_requests, &zip/1)]
    score = ZipCodeSessionScorer.score(zip(request), other_zips)

    class =
      case score do
        score when score >= 80 -> "best"
        score when score >= 60 -> "better"
        score when score >= 40 -> "good"
        _ -> "bad"
      end

    ~L"""
    <div class="badge <%= class %>"><%= score %></div>
    """
  end

  defp zip(%Request{nominee_zip_code: zip}) when is_binary(zip), do: zip

  defp zip(%Request{nominee_address: nominee_address}) do
    case Regex.run(~r/43\d{3}/, nominee_address) do
      [zip] -> zip
      _ -> "439#{Enum.random(10..99)}"
    end
  end

  defp adjust_priority(list, request_id, priority?) do
    Enum.map(list, fn request ->
      if "#{request.id}" == request_id do
        IO.inspect(priority?, label: "found #{request_id}")
        %{request | priority: priority?}
      else
        request
      end
    end)
  end
end
