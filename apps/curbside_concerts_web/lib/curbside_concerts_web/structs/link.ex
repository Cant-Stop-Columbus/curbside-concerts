defmodule CurbsideConcertsWeb.Structs.Link do
  @behaviour Access

  defstruct path: "", label: "", current: false

  @impl true
  def fetch(term, key) do
    term
    |> Map.from_struct()
    |> Map.fetch(key)
  end

  @impl true
  def get_and_update(data, key, function) do
    data
    |> Map.from_struct()
    |> Map.get_and_update(key, function)
  end

  @impl true
  def pop(data, key) do
    data
    |> Map.from_struct()
    |> Map.pop(key)
  end
end
