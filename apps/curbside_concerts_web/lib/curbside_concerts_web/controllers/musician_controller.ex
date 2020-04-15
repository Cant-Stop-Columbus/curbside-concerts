defmodule CurbsideConcertsWeb.MusicianController do
  @moduledoc """
  The controller for musician CRUD.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Musician

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Musicians.change_musician(%Musician{})
    action = Routes.musician_path(conn, :create)
    render(conn, "new.html", changeset: changeset, action: action)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
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

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _) do
    render(conn, "index.html", musicians: Musicians.all_musicians())
  end
end
