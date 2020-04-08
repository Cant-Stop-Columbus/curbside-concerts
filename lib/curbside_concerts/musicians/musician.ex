defmodule CurbsideConcerts.Musicians.Musician do
  @moduledoc """
  This schema represents a musician who can perform a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @allowed_attrs ~w|gigs_id name photo playlist taking_requests|a
  @required_attrs @allowed_attrs

  schema "musicians" do
    field(:gigs_id, :string)
    field(:name, :string)
    field(:photo, :binary)
    field(:playlist, {:array, :string})
    field(:taking_requests, :boolean)

    timestamps()
  end

  def changeset(musician, attrs) do
    musician
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
  end
end
