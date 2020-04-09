defmodule CurbsideConcerts.Musicians.Session do
  @moduledoc """
  This schema represents a musician's time out doing performances.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias CurbsideConcerts.Musicians.Musician

  @allowed_attrs ~w|name musician_id description start_time end_time|a
  @required_attrs ~w|name|a

  schema "sessions" do
    field(:name, :string)
    field(:description, :string)
    field(:start_time, :utc_datetime)
    field(:end_time, :utc_datetime)

    belongs_to :musician, Musician

    timestamps()
  end

  def changeset(musician, attrs) do
    musician
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
  end
end
