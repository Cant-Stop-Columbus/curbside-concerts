defmodule Hello.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @allowed_attrs ~w|nominee_name nominee_phone nominee_address song special_message requester_name requester_phone|a

  schema "requests" do
    field(:nominee_name, :string)
    field(:nominee_phone, :string)
    field(:nominee_address, :string)
    field(:song, :string)
    field(:special_message, :string)
    field(:requester_name, :string)
    field(:requester_phone, :string)

    timestamps()
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, @allowed_attrs)
  end
end
