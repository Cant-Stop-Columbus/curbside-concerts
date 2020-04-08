defmodule CurbsideConcertsWeb.AdminController do
  use CurbsideConcertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
