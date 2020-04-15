defmodule CurbsideConcertsWeb.Plugs.AuthenticateUser do
  @moduledoc """
  This plug checks the conn for the `user_signed_in?` property. If the property
  does not exist or is falsy, the application displays a message and redirects to
  the sign in page.

  Note: This plug depends on the SetCurrentUser plug being called somewhere
  in the main :browser pipeline.

  Example Usage:
  ```
  pipeline :browser do
    # ...
    plug(SetCurrentUser)
  end

  pipeline :requires_auth do
    plug AuthenticateUser
  end
  ```
  """

  import Plug.Conn
  import Phoenix.Controller

  alias CurbsideConcertsWeb.Router.Helpers, as: Routes

  @spec init(any) :: nil
  def init(_params) do
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
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
