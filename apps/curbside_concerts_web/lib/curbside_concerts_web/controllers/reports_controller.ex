defmodule CurbsideConcertsWeb.ReportsController do
  @moduledoc """
  A controller for admin report pages.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Requests

  def performances(conn, _params) do
    sessions = Musicians.all_sessions_and_requests()

    conn
    |> assign(:sessions, sessions)
    |> render("performances.html")
  end

  def genres(conn, _params) do
    unbooked_requests = Requests.all_unbooked_requests()

    conn
    |> assign(:unbooked_requests, unbooked_requests)
    |> render("genres.html")
  end
end
