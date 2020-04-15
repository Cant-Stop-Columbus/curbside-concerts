defmodule CurbsideConcerts.Repo.Migrations.AddFullAddressToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :nominee_street_address, :string
      add :nominee_city, :string
      add :nominee_zip_code, :string
      add :nominee_address_notes, :text
    end
  end
end
