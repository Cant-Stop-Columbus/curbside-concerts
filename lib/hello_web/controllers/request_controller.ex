defmodule HelloWeb.RequestController do
  use HelloWeb, :controller

  alias Hello.Requests
  alias Hello.Requests.Request

  def new(conn, _params) do
    changeset = Requests.change_request(%Request{})
    action = Routes.request_path(conn, :create)
    render(conn, "new.html", changeset: changeset, action: action)
  end

  def create(conn, %{"request" => request_params}) do
    case Requests.create_request(request_params) do
      {:ok, _request} ->
        conn
        |> put_flash(:info, "Thanks for submitting your request")
        |> redirect(to: Routes.request_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        action = Routes.request_path(conn, :create)

        conn
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html", changeset: changeset, action: action)
    end
  end

  def index(conn, _) do
    render(conn, "index.html", requests: Requests.all())
  end
end
