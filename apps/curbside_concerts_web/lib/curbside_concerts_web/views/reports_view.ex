defmodule CurbsideConcertsWeb.ReportsView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Requests.Request

  def genre_counts(unbooked_requests) when is_list(unbooked_requests) do
    counts =
      Enum.reduce(unbooked_requests, %{}, fn %Request{genres: genres}, acc ->
        if genres == [] do
          Map.update(acc, "No genre specified", 1, &(&1 + 1))
        else
          Enum.reduce(genres, acc, fn %Genre{name: genre_name}, acc ->
            Map.update(acc, genre_name, 1, &(&1 + 1))
          end)
        end
      end)
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, v} -> -v end)

    ~E"""
    <ol>
    <%= for {genre_name, count} <- counts do %>
      <li><%= count %> -- <%= genre_name %></li>
    <% end %>
    </ol>
    """
  end
end
