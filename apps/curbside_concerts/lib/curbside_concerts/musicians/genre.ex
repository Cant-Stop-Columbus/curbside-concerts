defmodule CurbsideConcerts.Musicians.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_attrs ~w|name archived|a
  @required_attrs ~w|name|a

  schema "genres" do
    field :name, :string
    field :archived, :boolean

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
