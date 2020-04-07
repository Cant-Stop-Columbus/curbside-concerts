defmodule CurbsideConcerts.Repo.Migrations.CreateSessionsTable do
  use Ecto.Migration

  def change do
    create table("sessions") do
      add :name, :string, null: false
      add :archived, :boolean, null: false, default: false
      add :musician_id, references(:musicians), null: false

      timestamps()
    end

    alter table("requests") do
      add :session_id, references(:sessions)
    end
  end
end
