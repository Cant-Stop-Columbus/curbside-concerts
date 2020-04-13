defmodule CurbsideConcerts.Repo.Migrations.AddArchivedColumnToRequestsTable do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :archived, :boolean, null: false, default: false
    end
  end
end
