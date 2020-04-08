defmodule CurbsideConcerts.Repo.Migrations.UpdateSessionDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      modify :description, :text
    end
  end
end
