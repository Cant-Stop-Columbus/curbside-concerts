defmodule Hello.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Hello.Musicians.Session

  @allowed_attrs ~w|contact_preference nominee_name nominee_phone nominee_address song special_message requester_name requester_phone session_id|a
  @required_attrs ~w|contact_preference nominee_name nominee_address song special_message requester_name requester_phone|a

  schema "requests" do
    field(:contact_preference, :string)
    field(:nominee_name, :string)
    field(:nominee_phone, :string)
    field(:nominee_address, :string)
    field(:song, :string)
    field(:special_message, :string)
    field(:requester_name, :string)
    field(:requester_phone, :string)

    belongs_to :session, Session

    timestamps()
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
  end
end
