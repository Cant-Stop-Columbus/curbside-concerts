defmodule CurbsideConcerts.AccountsTest do
  use CurbsideConcerts.DataCase

  import Mock

  alias CurbsideConcerts.Accounts
  alias CurbsideConcerts.Accounts.User

  describe "create_user/2" do
    test "given valid user data" do
      with_mock CurbsideConcerts.Accounts.Encryption,
        hash: fn "some password" -> "hashed_password" end do
        assert {:ok, %User{} = user} =
                 Accounts.create_user(%{
                   password: "some password",
                   username: "some username"
                 })

        assert user.password == "hashed_password"
        assert user.username == "some username"
      end
    end

    test "given missing username" do
      attrs = %{
        password: "password"
      }

      assert {:error, _} = Accounts.create_user(attrs)
    end

    test "given missing password" do
      attrs = %{
        username: "username"
      }

      assert {:error, _} = Accounts.create_user(attrs)
    end

    test "given duplicate username" do
      attrs = %{
        username: "username",
        password: "password"
      }

      Accounts.create_user(attrs)

      assert {:error, _} = Accounts.create_user(attrs)
    end
  end
end
