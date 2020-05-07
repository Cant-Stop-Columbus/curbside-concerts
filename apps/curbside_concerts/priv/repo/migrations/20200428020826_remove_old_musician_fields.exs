defmodule CurbsideConcerts.Repo.Migrations.RemoveOldMusicianFields do
  use Ecto.Migration

  def change do
    alter table("musicians") do
      remove :gigs_id, :string
      remove :playlist, :jsonb
      remove :taking_requests, :boolean
    end
  end
end
