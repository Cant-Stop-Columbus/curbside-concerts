defmodule HelloWeb.RequestController do
  use HelloWeb, :controller

  alias Hello.Requests
  alias Hello.Requests.Request
  alias Hello.Musicians

  def new(conn, %{"session_id" => session_id}) do
    session = Musicians.find_session(session_id)
    changeset = Requests.change_request(%Request{})
    action = Routes.request_path(conn, :create)
    render(conn, "new.html", changeset: changeset, action: action, session: session)
  end

  def home(conn, _) do
    sessions = Musicians.all_sessions()
    render(conn, "home.html", sessions: sessions)
  end

  def create(conn, %{"request" => request_params}) do
    case Requests.create_request(request_params) do
      {:ok, %Request{nominee_name: nominee_name}} ->
        conn
        |> put_flash(:info, "Thank you for submitting a concert request for #{nominee_name}!")
        |> redirect(to: Routes.request_path(conn, :home))

      {:error, %Ecto.Changeset{} = changeset} ->
        action = Routes.request_path(conn, :create)
        session = Musicians.find_session(request_params["session_id"])

        conn
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html", changeset: changeset, action: action, session: session)
    end
  end

  def index(conn, %{"musician" => gigs_id}) do
    render(conn, "index.html", requests: Requests.get_by_gigs_id(gigs_id))
  end

  def index(conn, _) do
    render(conn, "index.html", requests: Requests.all())
  end
end
