defmodule CurbsideConcertsWeb.Plugs.AuthenticateUser do
  @moduledoc """
  This plug checks the conn for the `user_signed_in?` property. If the property
  does not exist or is falsy, the application displays a message and redirects to
  the home page.

  Applying this plug to a controller will effectively restrict it to authenticated
  users.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias CurbsideConcertsWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: Routes.account_session_path(conn, :new))
      |> halt()
    end
  end
end
