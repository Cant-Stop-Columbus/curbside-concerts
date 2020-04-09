defmodule CurbsideConcertsWeb.GenreControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Accounts.User

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end

  describe "index" do
    test "lists all genres", %{conn: conn} do
      html =
        conn
        |> get(Routes.genre_path(conn, :index))
        |> html_response(200)

      assert html =~ "Genres"
    end
  end

  describe "new genre" do
    test "renders form", %{conn: conn} do
      html =
        conn
        |> get(Routes.genre_path(conn, :new))
        |> html_response(200)

      assert html =~ "New Genre"
    end
  end

  describe "create genre" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.genre_path(conn, :create), genre: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.genre_path(conn, :show, id)

      html =
        conn
        |> get(Routes.genre_path(conn, :show, id))
        |> html_response(200)

      assert html =~ "View Genre"
      assert html =~ "Genre created successfully"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      html =
        conn
        |> post(Routes.genre_path(conn, :create), genre: @invalid_attrs)
        |> html_response(200)

      assert html =~ "New Genre"
    end
  end

  describe "edit genre" do
    test "renders form for editing chosen genre", %{conn: conn} do
      genre = insert!(:genre)

      html =
        conn
        |> get(Routes.genre_path(conn, :edit, genre))
        |> html_response(200)

      assert html =~ "Edit Genre"
    end
  end

  describe "update genre" do
    test "redirects when data is valid", %{conn: conn} do
      genre = insert!(:genre)

      conn = put(conn, Routes.genre_path(conn, :update, genre), genre: @update_attrs)
      assert redirected_to(conn) == Routes.genre_path(conn, :show, genre)

      html =
        conn
        |> get(Routes.genre_path(conn, :show, genre))
        |> html_response(200)

      assert html =~ "View Genre"

      assert html =~ "Genre updated successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      genre = insert!(:genre)

      conn = put(conn, Routes.genre_path(conn, :update, genre), genre: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Genre"
    end
  end
end
