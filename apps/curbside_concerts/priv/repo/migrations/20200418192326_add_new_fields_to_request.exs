defmodule CurbsideConcerts.Repo.Migrations.AddNewFieldsToRequest do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :request_reason, :text
      add :nominee_description, :text
      add :special_message_sender_name, :string
      add :nominee_favorite_music_notes, :text
      add :request_occasion , :text
      add :preferred_date, :date
      add :nominee_email, :string
      add :requester_relationship, :text
      add :special_instructions, :text
      add :requester_newsletter_interest, :boolean
    end
  end
end
