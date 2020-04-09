defmodule CurbsideConcerts.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string
      add :archived, :boolean, default: false

      timestamps()
    end
  end
end
