defmodule CurbsideConcerts.Accounts.Encryption do
  @moduledoc """
  This module is responsible for password encryption.

  Currently it is implemented as a wrapper around `Comeonin.Bcrypt`.
  """

  alias CurbsideConcerts.Accounts.User
  alias Comeonin.Bcrypt

  @spec hash(binary) :: binary
  def hash(password), do: Bcrypt.hashpwsalt(password)

  @spec password_match?(User.t(), binary) :: {:error, binary} | {:ok, User.t()}
  def password_match?(nil, _password), do: {:error, "User not found"}

  def password_match?(%User{} = user, password),
    do: Bcrypt.check_pass(user, password, hash_key: :password)
end
