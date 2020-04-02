defmodule Hello.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @allowed_attrs ~w|nominee_name nominee_number nominee_address song special_message requester_name requester_number|a

  schema "request" do
    field(:nominee_name, :string)
    field(:nominee_number, :string)
    field(:nominee_address, :string)
    field(:song, :string)
    field(:special_message, :string)
    field(:requester_name, :string)
    field(:requester_number, :string)
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, @allowed_attrs)
  end
end
