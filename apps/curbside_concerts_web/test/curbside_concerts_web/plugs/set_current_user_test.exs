defmodule CurbsideConcertsWeb.Plugs.SetCurrentUserTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcertsWeb.Plugs.SetCurrentUser

  import CurbsideConcerts.Factory

  describe "call/2" do
    test "if the session user exists in the database, assign it to the conn", %{conn: conn} do
      %User{id: id} = user = insert!(:user)

      %{assigns: assigns} =
        conn
        |> bypass_through()
        |> with_authenticated_user(user)
        |> get(Routes.landing_path(conn, :index))
        |> SetCurrentUser.call(%{})

      assert %User{id: ^id} = assigns[:current_user]
      assert assigns[:user_signed_in?]
    end

    test "if the session user does not exist in the database, unset the assigns", %{conn: conn} do
      user = build(:user)

      %{assigns: assigns} =
        conn
        |> bypass_through()
        |> with_authenticated_user(user)
        |> get(Routes.landing_path(conn, :index))
        |> SetCurrentUser.call(%{})

      assert is_nil(assigns[:current_user])
      refute assigns[:user_signed_in?]
    end

    test "if no session user, unset the assigns", %{conn: conn} do
      %{assigns: assigns} =
        conn
        |> bypass_through()
        |> get(Routes.landing_path(conn, :index))
        |> fetch_session()
        |> SetCurrentUser.call(%{})

      assert is_nil(assigns[:current_user])
      refute assigns[:user_signed_in?]
    end
  end
end
