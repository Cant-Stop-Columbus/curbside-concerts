defmodule CurbsideConcerts.Repo.Migrations.CreateMusiciansTable do
  use Ecto.Migration

  def change do
    create table("musicians") do
      add :gigs_id, :string, null: false
      add :name, :string, null: false
      add :photo, :binary
      add :playlist, :jsonb, null: false, default: "[]"
      add :taking_requests, :boolean, null: false, default: true

      timestamps()
    end
  end
end
