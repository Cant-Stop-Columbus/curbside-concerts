defmodule HelloWeb.RequestView do
  use HelloWeb, :view

  def songs do
    [
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
    text_input(form, field, placeholder: "Your answer")
  end
end
