defmodule CurbsideConcerts.Requests.RequestGenre do
  use Ecto.Schema

  import Ecto.Changeset

  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Requests.Request

  schema "request_genres" do
    belongs_to :request, Request
    belongs_to :genre, Genre
    timestamps()
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, [:request_id, :genre_id])
    |> validate_required([:request_id, :genre_id])
  end
end
