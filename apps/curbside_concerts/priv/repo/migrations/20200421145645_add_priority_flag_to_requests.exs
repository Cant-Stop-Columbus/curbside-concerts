defmodule CurbsideConcerts.Repo.Migrations.AddPriorityFlagToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :priority, :boolean, null: false, default: false
    end
  end
end
