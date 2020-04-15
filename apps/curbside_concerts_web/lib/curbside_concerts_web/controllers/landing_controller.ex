defmodule CurbsideConcertsWeb.LandingController do
  @moduledoc """
  """

  use CurbsideConcertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
