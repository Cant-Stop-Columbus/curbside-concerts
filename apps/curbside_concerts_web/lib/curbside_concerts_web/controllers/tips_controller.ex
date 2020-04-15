defmodule CurbsideConcertsWeb.TipsController do
  @moduledoc """
  Controller for the static tips page.

  Note: This will probably get replaced by a data-driven musicians page.
  """

  use CurbsideConcertsWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
