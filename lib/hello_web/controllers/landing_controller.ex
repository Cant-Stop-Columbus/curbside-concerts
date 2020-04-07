defmodule HelloWeb.LandingController do
  @moduledoc """
  """

  use HelloWeb, :controller

  alias Hello.Musicians

  def index(conn, _params) do
    sessions = Musicians.all_sessions()

    render(conn, "index.html", sessions: sessions)
  end
end
