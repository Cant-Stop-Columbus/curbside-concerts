defmodule CurbsideConcertsWeb.Plugs.AuthenticateUserTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcertsWeb.Plugs.AuthenticateUser

  describe "call/2" do
    test "if user is signed in, return conn", %{conn: conn} do
      %{status: status} =
        conn
        |> bypass_through()
        |> assign(:user_signed_in?, true)
        |> get(Routes.landing_path(conn, :index))
        |> AuthenticateUser.call(%{})

      assert 302 != status
    end

    test "if user is not signed in, redirect to sign in page", %{conn: conn} do
      conn =
        conn
        |> bypass_through()
        |> assign(:user_signed_in?, false)
        |> get(Routes.landing_path(conn, :index))
        |> fetch_session()
        |> fetch_flash()
        |> AuthenticateUser.call(%{})

      assert redirected_to(conn) == Routes.account_session_path(conn, :new)

      html =
        conn
        |> get(redirected_to(conn))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "You need to be signed in to access that page." ==
               html |> Floki.find(".alert-danger") |> Floki.text()
    end
  end
end
