defmodule CurbsideConcerts.Repo.Migrations.AddDescriptionToSession do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :description, :string
    end
  end
end
