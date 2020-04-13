defmodule CurbsideConcertsWeb.SessionController do
  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcertsWeb.TrackerCypher

  def index(conn, %{"archived" => "true"}) do
    conn
    |> assign(:sessions, Musicians.all_archived_sessions())
    |> render("index.html", show_archived: true)
  end

  def index(conn, _params) do
    conn
    |> assign(:sessions, Musicians.all_active_sessions())
    |> render("index.html", show_archived: false)
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
          "Error submitting session. Please check below and try again."
        )
        |> render("edit.html")
    end
  end

  def archive(conn, %{"id" => id}) do
    session = Musicians.get_session(id)
    {:ok, _session} = Musicians.archive_session(session)

    conn
    |> put_flash(:info, "Session archived successfully.")
    |> redirect(to: Routes.session_path(conn, :index))
  end

  def session_route_driver(conn, %{"driver_id" => driver_id}) do
    driver_id = TrackerCypher.decode(driver_id)
    session = Musicians.find_session(driver_id)

    conn
    |> assign(:session, session)
    |> render("driver_session_route.html")
  end

  def session_route_artist(conn, %{"artist_id" => musician_id}) do
    musician_id = TrackerCypher.decode(musician_id)
    session = Musicians.find_session(musician_id)

    conn
    |> assign(:session, session)
    |> render("musician_session_route.html")
  end
end
