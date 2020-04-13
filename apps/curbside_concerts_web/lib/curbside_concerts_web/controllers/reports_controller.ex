defmodule CurbsideConcertsWeb.ReportsController do
  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Requests
  # alias CurbsideConcerts.Requests.Request

  def genres(conn, _params) do
    unbooked_requests = Requests.all_unbooked_requests()

    conn
    |> assign(:unbooked_requests, unbooked_requests)
    |> render("genres.html")
  end
end
