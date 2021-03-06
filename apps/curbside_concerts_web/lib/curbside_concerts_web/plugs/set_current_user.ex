defmodule CurbsideConcertsWeb.Plugs.SetCurrentUser do
  @moduledoc """
  This plug checks the session for a user object, and adds it to the conn
  as `current_user`. It also sets the `user_signed_in?` property to true or
  false, depending on whether a user is found.

  Example Usage:
  ```
  pipeline :browser do
    # ...
    plug(SetCurrentUser)
  end
  ```
  """

  import Plug.Conn

  alias CurbsideConcerts.Accounts

  @spec init(any) :: nil
  def init(_params) do
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if current_user = user_id && Accounts.get_user!(user_id) do
      conn
      |> assign(:current_user, current_user)
      |> assign(:user_signed_in?, true)
    else
      conn
      |> assign(:current_user, nil)
      |> assign(:user_signed_in?, false)
    end
  end
end
