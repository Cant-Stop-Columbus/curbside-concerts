defmodule Hello.Musicians.Session do
  @moduledoc """
  This schema represents a musician's time out doing performances.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Hello.Musicians.Musician

  @allowed_attrs ~w|name musician_id description|a
  @required_attrs ~w|name musician_id|a

  schema "sessions" do
    field(:name, :string)
    field(:description, :string)

    belongs_to :musician, Musician

    timestamps()
  end

  def changeset(musician, attrs) do
    musician
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
  end
end
