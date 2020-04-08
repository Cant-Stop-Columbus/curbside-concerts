defmodule CurbsideConcerts.Repo.Migrations.AddTimesToSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
    end
  end
end
