defmodule CurbsideConcertsWeb.AdminController do
  @moduledoc """
  The controller for the admin landing page, "/admin".
  """

  use CurbsideConcertsWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
