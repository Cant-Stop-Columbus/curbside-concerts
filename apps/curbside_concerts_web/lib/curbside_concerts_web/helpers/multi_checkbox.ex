defmodule CurbsideConcertsWeb.Helpers.MultiCheckbox do
  @moduledoc """
  This code was shamelessly swiped from: https://medium.com/@ricardoruwer/many-to-many-associations-in-elixir-and-phoenix-b4aa6d978f7b

  Renders multiple checkboxes.

  ## Example
  ```
  multiselect_checkboxes(
  f,
  :genres,
  Enum.map(@genres, fn c -> { c.name, c.id } end),
  selected: Enum.map(@changeset.data.genres,&(&1.id))
  )
  ```

  Results in:

  ```
  <div>
  <label>
  	<input name="request[genres][]" id="request_genres_1" type="checkbox" value="1" checked>
  	<input name="request[genres][]" id="request_genres_2" type="checkbox" value="2">
  </label>
  </div
  ```
  """

  use Phoenix.HTML

  def multiselect_checkboxes(form, field, options, opts \\ []) do
    {selected, _} = get_selected_values(form, field, opts)
    selected_as_strings = Enum.map(selected, &"#{&1}")

    for {value, key} <- options, into: [] do
      content_tag(:div) do
        content_tag(:label, class: "checkbox-field") do
          [
            tag(:input,
              name: input_name(form, field) <> "[]",
              id: input_id(form, field, key),
              type: "checkbox",
              value: key,
              checked: Enum.member?(selected_as_strings, "#{key}")
            ),
            content_tag(:span, value)
          ]
        end
      end
    end
  end

  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)

    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || input_value(form, field), opts}
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end
