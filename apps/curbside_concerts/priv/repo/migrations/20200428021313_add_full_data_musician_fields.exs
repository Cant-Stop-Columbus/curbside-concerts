defmodule CurbsideConcerts.Repo.Migrations.AddFullDataMusicianFields do
  use Ecto.Migration

  def change do
    alter table("musicians") do
      add :bio, :text
      add :url_pathname, :string
      add :default_session_title, :string
      add :default_session_description, :text
      add :facebook_url, :string
      add :twitter_url, :string
      add :instagram_url, :string
      add :website_url, :string
      add :youtube_url, :string
      add :cash_app_url, :string
      add :venmo_url, :string
      add :paypal_url, :string
    end

    create unique_index(:musicians, [:url_pathname])

  end
end
