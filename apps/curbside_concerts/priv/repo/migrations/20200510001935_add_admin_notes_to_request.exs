defmodule CurbsideConcerts.Repo.Migrations.AddAdminNotesToRequest do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :admin_notes, :text
    end
  end
end
