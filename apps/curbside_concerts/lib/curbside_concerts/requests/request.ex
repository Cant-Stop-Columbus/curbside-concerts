defmodule CurbsideConcerts.Requests.Request do
  @moduledoc """
  This schema represents a request for a concert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Requests.RequestGenre

  @allowed_attrs ~w|state contact_preference nominee_name nominee_phone nominee_address special_message requester_name requester_phone requester_email rank session_id archived|a
  @required_attrs ~w|state contact_preference nominee_name nominee_address special_message requester_name requester_phone requester_email|a

  schema "requests" do
    field(:state, :string, default: "pending")
    field(:contact_preference, :string)
    field(:nominee_name, :string)
    field(:nominee_phone, :string)
    field(:nominee_address, :string)
    field(:special_message, :string)
    field(:requester_name, :string)
    field(:requester_phone, :string)
    field(:requester_email, :string)
    field(:rank, :string)
    field(:archived, :boolean)

    # deprecated fields
    field(:song, :string)

    belongs_to :session, Session

    many_to_many :genres, Genre, join_through: RequestGenre

    timestamps()
  end

  def changeset(request, attrs) do
    attrs =
      attrs
      |> trim_attrs(@allowed_attrs)
      |> filter_phones()

    request
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs, message: "Please provide an answer")
    |> validate_phone(:requester_phone)
  end

  @doc """
  Do not want to get too picky here. If the input does not have 10 characters complain.
  """
  def validate_phone(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn f, value ->
      if is_binary(value) and String.length(value) < 10 do
        [{f, "Please complete this phone number"}]
      else
        []
      end
    end)
  end

  defp trim_attrs(%{} = map, fields) when is_list(fields) do
    field_keys = Enum.map(fields, &to_string/1)
    fields_to_trim = Map.take(map, field_keys)

    Map.merge(map, fields_to_trim, fn _key, _old_val, new_val ->
      if is_binary(new_val), do: String.trim(new_val), else: new_val
    end)
  end

  defp filter_phones(attrs) do
    attrs
    |> digitize_field("nominee_phone")
    |> digitize_field("requester_phone")
  end

  defp digitize_field(attrs, field) do
    if Map.has_key?(attrs, field), do: Map.update!(attrs, field, &digits_only/1), else: attrs
  end

  defp digits_only(string) when is_binary(string), do: String.replace(string, ~r/\D/, "")
  defp digits_only(not_string), do: not_string
end
