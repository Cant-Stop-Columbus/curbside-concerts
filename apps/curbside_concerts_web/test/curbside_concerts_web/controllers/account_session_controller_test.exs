defmodule CurbsideConcertsWeb.AccountSessionControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcerts.Accounts.User

  import CurbsideConcerts.Factory

  describe "new/2" do
    test "renders form", %{conn: conn} do
      html =
        conn
        |> get(Routes.account_session_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Sign In" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "create/2" do
    test "redirects to admin when data is valid", %{conn: conn} do
      %User{username: username, password: password} = insert!(:user)

      conn =
        post(conn, Routes.account_session_path(conn, :create),
          session: %{password: password, username: username}
        )

      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      html =
        conn
        |> get(Routes.admin_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Admin Page" == html |> Floki.find("h1") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      html =
        conn
        |> post(Routes.account_session_path(conn, :create),
          session: %{password: nil, username: nil}
        )
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Sign In" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert!(:user)

      conn =
        conn
        |> with_authenticated_user(user)

      %{conn: conn}
    end

    test "redirects to admin", %{conn: conn} do
      conn = delete(conn, Routes.account_session_path(conn, :delete))

      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      html =
        conn
        |> get(Routes.admin_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Admin Page" == html |> Floki.find("h1") |> Floki.text()
    end
  end
end
