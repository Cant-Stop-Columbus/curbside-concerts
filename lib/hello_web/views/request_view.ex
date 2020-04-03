defmodule HelloWeb.RequestView do
  use HelloWeb, :view

  alias Hello.Requests.Request

  def required_star do
    ~E|<span class="required">*</span>|
  end

  def songs do
    [
      {"Please choose a song", ""},
      "Piano Man",
      "Jack and Diane",
      "Let it Be",
      "Lay Down Sally",
      "Brick in the Wall",
      "Carolina In My Mind",
      "Hallelujah",
      "Ico Ico",
      "American Pie",
      "Blackbird",
      "The Times They Are A Changin'",
      "Heart of Gold",
      "Free Fallin'",
      "Country Roads",
      "Landslide",
      "Never Going Back Again",
      "Danny's Song",
      "Your Song",
      "Wish You Were Here",
      "Southern Cross",
      "One Way Out",
      "Down by The River",
      "Eleanor Rigby",
      "Song for No One",
      "Came in Through the Bathroom Window",
      "Hey Jude",
      "Gentle on My Mind",
      "Early Morning Rain"
    ]
  end

  def songs(playlist) when is_list(playlist) do
    [{"Please choose a song option", ""} | playlist]
  end

  def request_input(form, field) when field in ~w|special_message|a do
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
    <div>We'll call ahead when we're on our way. We can call you, or the requestee - please choose an option below. <%= required_star() %></div>
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

  def hero_image() do
    alt_text =
      "A man sitting in the bed of a pickup truck plays guitar for an elderly woman standing in her driveway. A speech bubble over the man says \"That song was for you. People care about you. This is from your daughter: 'Mom, we know it's hard to be alone but we want you to be safe. We hope this song brightens your day. We love you.'\""

    ~E"""
    <img src="/images/for_you.png" alt="<%= alt_text %>" />
    """
  end

  defp class(form, field) do
    if form.errors[field], do: "not-valid", else: ""
  end
end
