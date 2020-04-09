defmodule CurbsideConcerts.LexoRanker do
  @moduledoc """
  To be used for the ordering of DB records.

  For instance, Requests are to be ordered in sessions. Possible solutions
  could have been indexes or floating point values but both of those have
  potential problems.

  A lexo-like ranker gives a lot of flexibility with mitigated chances of
  have corrupt index/rank values. A collision with the solution is only
  possible if values are constantly moved to the top of a list dozens of times.

  If we ever start running into that we can look into writing jobs that
  recalculate rank to spread them out again.
  """

  @rank_length 8

  def calculate(above_rank, below_rank) do
    above_rank = format_rank(above_rank, pad_a(""))
    below_rank = format_rank(below_rank, pad_z(""))

    do_calculate("", above_rank, below_rank)
  end

  defp format_rank(rank, default) do
    case String.replace("#{rank}", ~r/[^a-z]/, "") do
      "" -> default
      rank -> pad_z(rank)
    end
    |> String.slice(0..(@rank_length - 1))
  end

  defp pad_a(rank, length \\ @rank_length) do
    pad(rank, "a", length)
  end

  defp pad_z(rank, length \\ @rank_length) do
    pad(rank, "z", length)
  end

  defp pad(rank, filler, length) do
    String.pad_trailing(rank, length, filler)
  end

  defp do_calculate(_acc, same, same) do
    same
  end

  defp do_calculate(acc, <<above_head>> <> _ = above_rank, <<below_head>> <> _ = below_rank)
       when below_head < above_head do
    # You gave us values in the wrong order
    # Just calculating the middle anyway but should we error out instead?
    do_calculate(acc, below_rank, above_rank)
  end

  defp do_calculate(acc, <<same_head>> <> above_rest, <<same_head>> <> below_rest) do
    do_calculate(acc <> <<same_head>>, above_rest, below_rest)
  end

  defp do_calculate(
         acc,
         <<above_head>> <> above_rest = above_rank,
         <<below_head>> <> below_rest = below_rank
       )
       when above_head + 1 == below_head do
    pad_length = @rank_length - String.length(acc)

    cond do
      above_rest =~ ~r/^z+$/ ->
        do_calculate(acc, pad_a(<<below_head>>, pad_length), below_rank)

      below_rest =~ ~r/^a+$/ ->
        do_calculate(acc, above_rank, pad_z(<<above_head>>, pad_length))

      true ->
        pad_z(acc <> <<above_head>>)
    end
  end

  defp do_calculate(acc, <<above_head>> <> above_rest, <<below_head>> <> _below_rest) do
    pad_length = @rank_length - String.length(acc)
    new_head = Integer.floor_div(above_head + below_head, 2)

    if new_head == above_head do
      do_calculate(acc <> <<above_head>>, above_rest, pad_z("", pad_length))
    else
      pad_z(acc <> <<new_head>>)
    end
  end
end
