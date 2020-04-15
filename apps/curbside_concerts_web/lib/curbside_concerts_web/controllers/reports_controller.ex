defmodule CurbsideConcertsWeb.ReportsController do
  @moduledoc """
  A controller for admin report pages.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Requests

  def genres(conn, _params) do
    unbooked_requests = Requests.all_unbooked_requests()

    conn
    |> assign(:unbooked_requests, unbooked_requests)
    |> render("genres.html")
  end
end
