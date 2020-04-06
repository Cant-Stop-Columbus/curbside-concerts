defmodule Hello.AccountsTest do
  use Hello.DataCase

  import Mock

  alias Hello.Accounts
  alias Hello.Accounts.User

  describe "create_user/2" do
    test "given valid user data" do
      with_mock Hello.Accounts.Encryption,
        hash: fn "some password" -> "hashed_password" end do
        assert {:ok, %User{} = user} =
                 Accounts.create_user(%{
                   encrypted_password: "some password",
                   username: "some username"
                 })

        assert user.encrypted_password == "hashed_password"
        assert user.username == "some username"
      end
    end

    test "given missing username" do
      attrs = %{
        encrypted_password: "encrypted_password"
      }

      assert {:error, _} = Accounts.create_user(attrs)
    end

    test "given missing encrypted_password" do
      attrs = %{
        username: "username"
      }

      assert {:error, _} = Accounts.create_user(attrs)
    end

    test "given duplicate username" do
      attrs = %{
        username: "username",
        encrypted_password: "encrypted_password"
      }

      Accounts.create_user(attrs)

      assert {:error, _} = Accounts.create_user(attrs)
    end
  end
end
