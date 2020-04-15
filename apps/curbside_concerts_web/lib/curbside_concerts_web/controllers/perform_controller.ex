defmodule CurbsideConcertsWeb.PerformController do
  @moduledoc """
  The controller for the /perform static page, which contains information
  for artists who want to become performers of Curbside Concerts.
  """

  use CurbsideConcertsWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
