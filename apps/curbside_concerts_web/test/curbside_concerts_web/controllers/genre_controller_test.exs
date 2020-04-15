defmodule CurbsideConcertsWeb.GenreControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Musicians.Genre

  setup %{conn: conn} do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end

  describe "index" do
    test "lists all active genres", %{conn: conn} do
      %Genre{name: active_name} =
        insert!(:genre, %{
          archived: false
        })

      %Genre{name: archived_name} =
        insert!(:genre, %{
          archived: true
        })

      html =
        conn
        |> get(Routes.genre_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Genres" == html |> Floki.find("h1") |> Floki.text()
      assert html |> Floki.text() =~ active_name
      refute html |> Floki.text() =~ archived_name
    end

    test "lists all archived genres", %{conn: conn} do
      %Genre{name: active_name} =
        insert!(:genre, %{
          archived: false
        })

      %Genre{name: archived_name} =
        insert!(:genre, %{
          archived: true
        })

      html =
        conn
        |> get(Routes.genre_path(conn, :index, %{"archived" => "true"}))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Genres" == html |> Floki.find("h1") |> Floki.text()
      refute html |> Floki.text() =~ active_name
      assert html |> Floki.text() =~ archived_name
    end
  end

  describe "new genre" do
    test "renders form", %{conn: conn} do
      html =
        conn
        |> get(Routes.genre_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "New Genre" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "create genre" do
    test "redirects to show when data is valid", %{conn: conn} do
      create_attrs = attrs(:genre)

      conn = post(conn, Routes.genre_path(conn, :create), genre: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.genre_path(conn, :show, id)

      html =
        conn
        |> get(Routes.genre_path(conn, :show, id))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Genre" == html |> Floki.find("h1") |> Floki.text()
      assert "Genre created successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{
        name: nil
      }

      html =
        conn
        |> post(Routes.genre_path(conn, :create), genre: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "New Genre" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "edit genre" do
    test "renders form for editing chosen genre", %{conn: conn} do
      genre = insert!(:genre)

      html =
        conn
        |> get(Routes.genre_path(conn, :edit, genre))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Genre" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "update genre" do
    test "redirects when data is valid", %{conn: conn} do
      genre = insert!(:genre)

      update_attrs = %{
        name: "updated"
      }

      conn = put(conn, Routes.genre_path(conn, :update, genre), genre: update_attrs)
      assert redirected_to(conn) == Routes.genre_path(conn, :show, genre)

      html =
        conn
        |> get(Routes.genre_path(conn, :show, genre))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Genre" == html |> Floki.find("h1") |> Floki.text()
      assert "Genre updated successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      genre = insert!(:genre)

      invalid_attrs = %{
        name: nil
      }

      html =
        conn
        |> put(Routes.genre_path(conn, :update, genre), genre: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Genre" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "archive/2" do
    test "archives genre", %{conn: conn} do
      %Genre{name: name} = genre = insert!(:genre)

      conn = get(conn, Routes.genre_path(conn, :index))
      assert html_response(conn, 200) =~ name

      conn = put(conn, Routes.genre_path(conn, :archive, genre))
      assert redirected_to(conn) == Routes.genre_path(conn, :index)

      html =
        conn
        |> get(Routes.genre_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Genre archived successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end
  end
end
