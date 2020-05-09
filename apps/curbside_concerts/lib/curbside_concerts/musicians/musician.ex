defmodule CurbsideConcerts.Musicians.Musician do
  @moduledoc """
  This schema represents a musician who can perform a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @allowed_attrs ~w|name bio url_pathname default_session_title default_session_description facebook_url twitter_url instagram_url website_url youtube_url cash_app_url venmo_url paypal_url|a
  @required_attrs ~w|name bio url_pathname|a

  schema "musicians" do
    field(:name, :string)
    field(:bio, :string)
    field(:url_pathname, :string)
    field(:photo, :binary)
    field(:default_session_title, :string)
    field(:default_session_description, :string)
    field(:facebook_url, :string)
    field(:twitter_url, :string)
    field(:instagram_url, :string)
    field(:website_url, :string)
    field(:youtube_url, :string)
    field(:cash_app_url, :string)
    field(:venmo_url, :string)
    field(:paypal_url, :string)

    timestamps()
  end

  def changeset(musician, attrs) do
    musician
    |> cast(attrs, @allowed_attrs)
    |> cast_image(attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
    |> validate_format(:url_pathname, ~r/^\S*$/)
    |> unique_constraint(:url_pathname)
  end

  defp cast_image(changeset, attrs) do
    photo = Map.get(attrs, "photo") || Map.get(attrs, :photo)
    case photo do
      %Plug.Upload{path: path} -> 
        changeset
        |> put_change(:photo, :base64.encode(File.read!(path)))
      _ -> 
        changeset
    end
  end
end
