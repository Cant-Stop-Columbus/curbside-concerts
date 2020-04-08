defmodule CurbsideConcerts.Repo.Migrations.AddStateToRequest do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :state, :string
    end
  end
end
