defmodule CurbsideConcerts.Repo.Migrations.AddRankToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :rank, :string
    end
  end
end
