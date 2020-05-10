defmodule CurbsideConcerts.Repo.Migrations.AddPhotoLinkToMusicians do
  use Ecto.Migration

  def change do
    alter table("musicians") do
      add :photo_url, :string
    end 
  end
end
