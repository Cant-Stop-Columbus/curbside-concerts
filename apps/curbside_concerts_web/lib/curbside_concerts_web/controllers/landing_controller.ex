defmodule CurbsideConcertsWeb.LandingController do
  @moduledoc """
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians

  def index(conn, _params) do
    sessions = Musicians.all_active_sessions()

    render(conn, "index.html", sessions: sessions)
  end
end
