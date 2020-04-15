defmodule CurbsideConcertsWeb.LandingController do
  @moduledoc """
  The controller for the static landing page at "/", which acts as an entry
  point for the requester experience.
  """

  use CurbsideConcertsWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
