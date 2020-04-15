defmodule CurbsideConcertsWeb.AccountSessionController do
  @moduledoc """
  The controller for session management, which is used to track authenticated users.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Accounts

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    render(conn, "new.html")
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"session" => auth_params}) do
    case Accounts.get_authenticated_user(auth_params["username"], auth_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, _err} ->
        conn
        |> put_flash(:error, "There was a problem with your username/password")
        |> render("new.html")
    end
  end

  @spec delete(Plug.Conn.t(), any) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end
end
