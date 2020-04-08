defmodule CurbsideConcertsWeb.SessionController do
  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Session

  def index(conn, _) do
    conn
    |> assign(:sessions, Musicians.all_sessions())
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Musicians.change_session(%Session{}))
    |> assign(:musicians, Musicians.all_musicians())
    |> render("new.html")
  end

  def create(conn, %{"session" => session_params}) do
    case Musicians.create_session(session_params) do
      {:ok, session} ->
        conn
        |> put_flash(:info, "Session created successfully.")
        |> redirect(to: Routes.session_path(conn, :show, session))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:musicians, Musicians.all_musicians())
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:session, Musicians.find_session(id))
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    changeset =
      id
      |> Musicians.find_session()
      |> Musicians.change_session()

    conn
    |> assign(:changeset, changeset)
    |> assign(:musicians, Musicians.all_musicians())
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Musicians.find_session(id)

    case Musicians.update_session(session, session_params) do
      {:ok, session} ->
        conn
        |> put_flash(:info, "Session updated successfully.")
        |> redirect(to: Routes.session_path(conn, :show, session))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:musicians, Musicians.all_musicians())
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html")
    end
  end
end
