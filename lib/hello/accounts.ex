defmodule Hello.Accounts do
  @moduledoc """
  This module contains helpers that interact with user accounts. An "account"
  consists of an Accounts.User object that is stored in the users table.
  """

  alias Hello.Accounts.Encryption
  alias Hello.Accounts.User
  alias Hello.Repo

  @spec get_user!(integer) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @spec create_user(Map.t()) :: {:ok, Schema.t()} | {:error, Changeset.t()}
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec change_user(User.t()) :: Changeset.t()
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @spec get_authenticated_user(binary, binary) :: {:error, binary} | {:ok, User.t()}
  def get_authenticated_user(username, password) do
    username
    |> get_user_by_username()
    |> Encryption.password_match?(password)
  end

  defp get_user_by_username(nil), do: nil
  defp get_user_by_username(username), do: Repo.get_by(User, username: username)
end
