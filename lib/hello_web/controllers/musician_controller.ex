defmodule HelloWeb.MusicianController do
  use HelloWeb, :controller

  alias Hello.Musicians
  alias Hello.Musicians.Musician

  def new(conn, _params) do
    changeset = Musicians.change_musician(%Musician{})
    action = Routes.musician_path(conn, :create)
    render(conn, "new.html", changeset: changeset, action: action)
  end

  def create(conn, %{"musician" => musician_params}) do
    case Musicians.create_musician(musician_params) do
      {:ok, _musician} ->
        conn
        |> put_flash(:info, "Thanks for adding a musician")
        |> redirect(to: Routes.musician_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        action = Routes.musician_path(conn, :create)

        conn
        |> put_flash(
          :error,
          "Oops! Looks like a field is missing - please check below and try again"
        )
        |> render("new.html", changeset: changeset, action: action)
    end
  end

  def index(conn, _) do
    render(conn, "index.html", musicians: Musicians.all_musicians())
  end
end
