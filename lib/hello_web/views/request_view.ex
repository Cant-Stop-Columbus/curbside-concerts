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

  defp class(form, field) do
    if form.errors[field], do: "not-valid", else: ""
  end
end
