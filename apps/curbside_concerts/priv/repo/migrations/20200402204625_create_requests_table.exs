defmodule CurbsideConcerts.Repo.Migrations.CreateRequestsTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:requests) do
      add :nominee_name, :string
      add :nominee_phone, :string
      add :nominee_address, :string
      add :song, :string
      add :special_message, :text
      add :requester_name, :string
      add :requester_phone, :string

      timestamps()
    end
  end
end
