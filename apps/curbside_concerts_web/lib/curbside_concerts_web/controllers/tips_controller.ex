defmodule CurbsideConcertsWeb.TipsController do
  @moduledoc """
  Controller for the static tips page.

  Note: This will probably get replaced by a data-driven musicians page.
  """

  use CurbsideConcertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
