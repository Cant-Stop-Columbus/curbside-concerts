defmodule Hello.Repo.Migrations.AddContactPreferenceToRequestsTable do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :contact_preference, :string
    end
  end
end
