defmodule CurbsideConcertsWeb.TrackerCypher do
  @moduledoc """
  Turn the primary key ids into a hashed code we can decode.

  This lets us expose obfuscated URLs to users not logged in.

  The cypher is function instead of a module attribute to avoid problems
  with looking for environment variables.
  """
  @min_length 12

  defp cypher do
    Hashids.new(
      # using a custom salt helps producing unique cipher text
      salt: "123456",
      # minimum length of the cipher text (1 by default)
      min_len: @min_length
    )
  end

  def encode(number) when is_integer(number) do
    Hashids.encode(cypher(), number)
  end

  def decode(code) when is_binary(code) do
    # if String.length(code) == @min_length do
    cypher()
    |> Hashids.decode!(code)
    |> List.first()

    # else
    #   0
    # end
  end
end
