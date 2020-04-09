defmodule CurbsideConcerts.Repo.Migrations.MakeSessionMusicianRelationOptional do
  use Ecto.Migration
  alias CurbsideConcerts.Repo
  alias CurbsideConcerts.Musicians.Musician

  import Ecto.Query, only: [from: 2]

  def up do
    drop constraint(:sessions, "sessions_musician_id_fkey")

    alter table(:sessions) do
      modify :musician_id, references(:musicians), null: true
    end
  end

  def down do
    # Create a "null" musician to assign any unfilled columns to
    %Musician{id: musician_id} = Repo.insert!(%Musician{name: "No Musician", gigs_id: "null"})

    from(session in "sessions", update: [set: [musician_id: ^musician_id]])
    |> Repo.update_all([])

    # Continue with the migration
    drop constraint(:sessions, "sessions_musician_id_fkey")

    alter table(:sessions) do
      modify :musician_id, references(:musicians), null: false
    end
  end
end
