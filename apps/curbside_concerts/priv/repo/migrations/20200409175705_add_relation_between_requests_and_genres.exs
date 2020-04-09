defmodule CurbsideConcerts.Repo.Migrations.AddRelationBetweenRequestsAndGenres do
  use Ecto.Migration

  def change do
    create table(:request_genres) do
      add :request_id, references(:requests)
      add :genre_id, references(:genres)
      timestamps()
    end
  end
end
