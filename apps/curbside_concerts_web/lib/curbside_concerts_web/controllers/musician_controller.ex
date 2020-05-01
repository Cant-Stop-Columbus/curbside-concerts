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
        |> put_flash(:info, "Musician added!")
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

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    musician = Musicians.get_musician(id)
    render(conn, "show.html", musician: musician)
  end

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _) do
    render(conn, "index.html", musicians: Musicians.all_musicians())
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    musician = Musicians.get_musician(id)
    changeset = Musicians.change_musician(musician)
    render(conn, "edit.html", musician: musician, changeset: changeset)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "musician" => musician_params}) do
    musician = Musicians.get_musician(id)

    case Musicians.update_musician(musician, musician_params) do
      {:ok, musician} ->
        conn
        |> put_flash(:info, "Musician updated successfully.")
        |> redirect(to: Routes.musician_path(conn, :show, musician))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", musician: musician, changeset: changeset)
    end
  end
end
