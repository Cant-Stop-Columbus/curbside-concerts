defmodule Hello.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:encrypted_password, :string)

      timestamps()
    end

    create(unique_index(:users, [:username]))
  end
end
