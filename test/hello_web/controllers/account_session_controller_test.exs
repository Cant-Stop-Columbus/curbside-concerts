defmodule HelloWeb.SessionControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Accounts.User
  alias Hello.Repo

  describe "new/2" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.account_session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign In"
    end
  end

  describe "create/2" do
    test "redirects to admin when data is valid", %{conn: conn} do
      user_params = %{
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      }

      %User{}
      |> User.changeset(user_params)
      |> Repo.insert!()

      conn =
        post(conn, Routes.account_session_path(conn, :create),
          session: %{password: user_params.password, username: user_params.username}
        )

      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Sign Out"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_session_path(conn, :create),
          session: %{password: nil, username: nil}
        )

      assert html_response(conn, 200) =~ "Sign In"
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user_params = %{
        username: Faker.Internet.user_name(),
        password: Faker.String.base64()
      }

      %User{}
      |> User.changeset(user_params)
      |> Repo.insert!()

      conn =
        post(conn, Routes.account_session_path(conn, :create),
          session: %{password: user_params.password, username: user_params.username}
        )

      %{conn: conn}
    end

    test "redirects to admin", %{conn: conn} do
      conn = delete(conn, Routes.account_session_path(conn, :delete))

      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Sign In"
    end
  end
end