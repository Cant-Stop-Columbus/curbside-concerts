defmodule CurbsideConcertsWeb.RequestView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcertsWeb.Helpers.RequestAddress

  def required_star do
    ~E|<span class="required">*</span>|
  end

  @pending_state Requests.pending_state()
  @accepted_state Requests.accepted_state()
  @enroute_state Requests.enroute_state()
  @arrived_state Requests.arrived_state()
  @completed_state Requests.completed_state()
  @canceled_state Requests.canceled_state()
  @offmission_state Requests.offmission_state()

  @doc """
  Given either a Request or a string representating a request
  state, returns the message text associated with that state.

  If the request does not have a state property, or the state
  is not recognized, an unknown message will be returned.
  """
  @spec display_state(Request.t()) :: binary()
  @spec display_state(binary()) :: binary()
  def display_state(%Request{state: state}) do
    display_state(state)
  end

  def display_state(state) when is_binary(state) do
    case state do
      @pending_state -> pending_message()
      @accepted_state -> accepted_message()
      @enroute_state -> enroute_message()
      @arrived_state -> arrived_message()
      @completed_state -> completed_message()
      @canceled_state -> canceled_message()
      @offmission_state -> offmission_message()
      _ -> unknown_message()
    end
  end

  def display_state(_), do: unknown_message()

  def cancellable_state(%Request{state: state}) do
    case state do
      @pending_state -> true
      @accepted_state -> true
      @enroute_state -> false
      @arrived_state -> false
      @completed_state -> false
      @canceled_state -> false
      @offmission_state -> false
      _ -> true
    end
  end

  def pending_message, do: "Received"
  def accepted_message, do: "Accepted"
  def enroute_message, do: "On the way"
  def arrived_message, do: "Arrived"
  def completed_message, do: "Completed"
  def canceled_message, do: "Canceled"
  def offmission_message, do: "Off-mission"
  def unknown_message, do: "Unknown"

  def progress do
    [
      pending_message(),
      accepted_message(),
      enroute_message(),
      arrived_message(),
      completed_message()
    ]
  end

  def request_cards(requests) when is_list(requests) do
    ~E"""
    <%= for request <- requests do %>
      <%= request_card(request) %>
    <% end %>
    """
  end

  def request_card(request) do
    ~E"""
    <%= render "request_card.html", request: request %>
    """
  end

  def map_route_link(requests) do
    truck_location = "491 W Broad St., Columbus, OH 43215"

    addresses =
      requests
      |> Enum.map(fn %Request{nominee_address: address} -> address end)
      |> Enum.join("/")

    link("Map this #{length(requests)} concert route",
      to: "https://www.google.com/maps/dir/#{truck_location}/#{addresses}/#{truck_location}",
      target: "_blank"
    )
  end

  def first_name(%Session{musician: %Musician{name: name}}) do
    name
    |> String.split()
    |> List.first()
  end

  def songs(playlist) when is_list(playlist) do
    [{"Please choose a song option", ""} | playlist]
  end

  def request_input(form, field, type: :phone) do
    class = class(form, field)

    ~E"""
    <%= telephone_input(form, field, class: class, placeholder: "Your answer") %>
    <%= error_tag form, field %>
    """
  end

  def request_input(form, field, type: :email) do
    class = class(form, field)

    ~E"""
    <%= email_input(form, field, class: class, placeholder: "Your answer") %>
    <%= error_tag form, field %>
    """
  end

  def request_input(form, field) when field in ~w|special_message nominee_address_notes|a do
    class = class(form, field)

    ~E"""
    <%= textarea(form, field, class: class, placeholder: "Your answer") %>
    <%= error_tag form, field %>
    """
  end

  def request_input(form, field) do
    class = class(form, field)

    ~E"""
    <%= text_input(form, field, class: class, placeholder: "Your answer") %>
    <%= error_tag form, field %>
    """
  end

  def request_select(form, field, options) do
    class = class(form, field)

    ~E"""
    <%= select(form, field, options, class: class) %>
    <%= error_tag form, field %>
    """
  end

  def contact_preference_radio(form) do
    class = class(form, :contact_preference)

    ~E"""
    <div>We'll call ahead when we're on our way (about 15 to 30 minutes before we arrive). Given that some older folks can be skeptical of calls... you have the option for us to call you, or the nominee - please choose an option below. <%= required_star() %></div>
      <label class="radio-button">
        <%= radio_button form, :contact_preference, :call_nominee, class: class %> <span>Call the nominee.</span>
      </label>
      <label class="radio-button">
        <%= radio_button form, :contact_preference, :call_requester, class: class %> <span>Call me and I'll contact the nominee.</span>
      </label>
      <label class="radio-button">
        <%= radio_button form, :contact_preference, :text_requester, class: class %> <span>Text me and I'll contact the nominee.</span>
      </label>
    """
  end

  def contact_preference(%Request{
        contact_preference: "call_nominee",
        nominee_name: name,
        nominee_phone: phone
      }),
      do: ~E"Call Nominee (<%= name %>) @ <%= phone_link(phone) %>"

  def contact_preference(%Request{
        contact_preference: "call_requester",
        requester_name: name,
        requester_phone: phone
      }),
      do: ~E"Call Requester (<%= name %>) @ <%= phone_link(phone) %>"

  def contact_preference(%Request{
        contact_preference: "text_requester",
        requester_name: requester_name,
        requester_phone: phone,
        nominee_name: nominee_name,
        song: song,
        session: %Session{
          musician: %Musician{
            name: musician_name
          }
        }
      }) do
    message =
      "Hi there, #{requester_name}! This text is to let you know #{musician_name} is coming soon to play #{
        song
      } for #{nominee_name}."
      |> URI.encode()
      |> String.replace("&", "%26")

    ~E"Text Requester (<%= requester_name %>) @ <%= text_link(phone, message) %>"
  end

  def contact_preference(%Request{contact_preference: preference}), do: preference

  def text_link(raw_number, message) do
    case simple_number(raw_number) do
      nil ->
        raw_number

      number ->
        ~E|<a href="sms:<%= number %>&body=<%= message %>">Text <%= raw_number %></a>|
    end
  end

  def phone_link(raw_number) do
    case simple_number(raw_number) do
      nil ->
        raw_number

      number ->
        ~E|<a href="tel:<%= number %>">Phone <%= raw_number %></a>|
    end
  end

  defp simple_number(number) when is_binary(number) do
    number = String.replace(number, ~r/\D/, "")
    if String.length(number) >= 10, do: number, else: nil
  end

  defp simple_number(_), do: nil

  defp class(form, field) do
    if form.errors[field], do: "not-valid", else: ""
  end
end
