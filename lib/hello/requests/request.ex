defmodule Hello.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  schema "request" do
  end

  def changeset(request, _attrs) do
    request
  end
end
