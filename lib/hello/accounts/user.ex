defmodule Hello.Accounts.User do
  @moduledoc """
  This schema represents a user account.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Hello.Accounts.Encryption

  schema "users" do
    field(:encrypted_password, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password])
    |> validate_required([:username, :encrypted_password])
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &Encryption.hash/1)
  end
end
