defmodule CurbsideConcerts.Repo.Migrations.AddEmailToRequestsTable do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :requester_email, :string
    end
  end
end
