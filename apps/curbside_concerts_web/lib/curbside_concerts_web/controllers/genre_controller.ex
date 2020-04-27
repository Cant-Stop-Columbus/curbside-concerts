defmodule CurbsideConcertsWeb.GenreController do
  @moduledoc """
  The controller for genre CRUD.
  """

  use CurbsideConcertsWeb, :controller

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Genre

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, %{"archived" => "true"}) do
    conn
    |> assign(:genres, Musicians.all_archived_genres())
    |> assign(:show_archived, true)
    |> render("index.html")
  end

  def index(conn, _params) do
    conn
    |> assign(:genres, Musicians.all_active_genres())
    |> assign(:show_archived, false)
    |> render("index.html")
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Musicians.change_genre(%Genre{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"genre" => genre_params}) do
    case Musicians.create_genre(genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre created successfully.")
        |> redirect(to: Routes.genre_path(conn, :show, genre))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    genre = Musicians.get_genre(id)
    render(conn, "show.html", genre: genre)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    genre = Musicians.get_genre(id)
    changeset = Musicians.change_genre(genre)
    render(conn, "edit.html", genre: genre, changeset: changeset)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Musicians.get_genre(id)

    case Musicians.update_genre(genre, genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre updated successfully.")
        |> redirect(to: Routes.genre_path(conn, :show, genre))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", genre: genre, changeset: changeset)
    end
  end

  @spec archive(Plug.Conn.t(), map) :: Plug.Conn.t()
  def archive(conn, %{"id" => id}) do
    genre = Musicians.get_genre(id)
    {:ok, _genre} = Musicians.archive_genre(genre)

    conn
    |> put_flash(:info, "Genre archived successfully.")
    |> redirect(to: Routes.genre_path(conn, :index))
  end

  @spec unarchive(Plug.Conn.t(), map) :: Plug.Conn.t()
  def unarchive(conn, %{"id" => id}) do
    genre = Musicians.get_genre(id)
    {:ok, _genre} = Musicians.unarchive_genre(genre)

    conn
    |> put_flash(:info, "Genre unarchived successfully.")
    |> redirect(to: Routes.genre_path(conn, :index))
  end
end
