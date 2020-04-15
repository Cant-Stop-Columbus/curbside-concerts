defmodule CurbsideConcerts.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Requests.RequestGenre

  @allowed_attrs ~w|state contact_preference nominee_name nominee_phone nominee_address nominee_street_address nominee_city nominee_zip_code nominee_address_notes special_message requester_name requester_phone requester_email rank session_id archived|a
  @required_attrs ~w|state contact_preference nominee_name nominee_street_address nominee_city nominee_zip_code special_message requester_name requester_phone requester_email|a

  schema "requests" do
    field(:state, :string, default: "pending")
    field(:contact_preference, :string)
    field(:nominee_name, :string)
    field(:nominee_street_address, :string)
    field(:nominee_city, :string)
    field(:nominee_zip_code, :string)
    field(:nominee_address_notes, :string)
    field(:nominee_phone, :string)
    field(:special_message, :string)
    field(:requester_name, :string)
    field(:requester_phone, :string)
    field(:requester_email, :string)
    field(:rank, :string)
    field(:archived, :boolean)

    
    # deprecated fields
    field(:song, :string)
    field(:nominee_address, :string)

    belongs_to :session, Session

    many_to_many :genres, Genre, join_through: RequestGenre

    timestamps()
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
  end
end
