defmodule HelloWeb.SessionController do
  use HelloWeb, :controller

  alias Hello.Musicians
  alias Hello.Musicians.Session

  def new(conn, _params) do
    changeset = Musicians.change_session(%Session{})
    action = Routes.session_path(conn, :create)
    musicians = Musicians.all()
    render(conn, "new.html", changeset: changeset, action: action, musicians: musicians)
  end

  def create(conn, %{"session" => session_params}) do
    case Musicians.create_session(session_params) do
      {:ok, _session} ->
        conn
        |> put_flash(:info, "Thanks for adding a session")
        |> redirect(to: Routes.session_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        action = Routes.session_path(conn, :create)
        musicians = Musicians.all()

        conn
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html", changeset: changeset, action: action, musicians: musicians)
    end
  end

  def index(conn, _) do
    render(conn, "index.html", sessions: Musicians.all_sessions())
  end
end
