defmodule CurbsideConcertsWeb.ZipCodeSessionScorer do
  @moduledoc """
  Columbus ZIP code scorer. Based off of the proximity of ZIP codes,
  a score can be awarded to a ZIP in relation to other ZIPs.

  This is to be used in the session booker to give a better idea
  which requests are in the route area.
  """

  alias CurbsideConcertsWeb.ZipCodeDistanceStore

  @connected_zips %{
    004 => [062, 054, 230, 213, 068],
    013 => [074, 031],
    016 => [064, 017, 065, 235, 026],
    017 => [016, 235, 064],
    021 => [074, 082, 035],
    026 => [016, 119, 162],
    031 => [013, 074, 021, 082],
    035 => [021, 065, 240, 082],
    040 => [061, 064],
    054 => [031, 081, 230, 004, 062],
    061 => [040],
    062 => [054, 004, 068],
    064 => [040, 016, 026, 054],
    065 => [016, 107, 235, 035],
    068 => [062, 004, 213, 232, 147],
    074 => [013, 031, 021],
    081 => [082, 231, 230, 054],
    082 => [021, 031, 081, 240, 035],
    085 => [235, 214, 229],
    102 => [130, 110],
    103 => [102, 110, 125, 137, 146, 116],
    110 => [130, 147, 068, 232, 125, 136, 112],
    112 => [110],
    116 => [103, 146],
    119 => [162, 026, 228, 123],
    123 => [146, 140, 119, 228, 204, 223],
    125 => [110, 217, 232, 207, 137],
    126 => [146],
    130 => [110, 102],
    136 => [110],
    137 => [217, 125, 207, 103],
    140 => [123, 146],
    143 => [146],
    146 => [126, 140, 123, 116, 143, 103, 137],
    147 => [068, 110],
    162 => [119, 026],
    201 => [202, 211, 219, 203, 215, 212],
    202 => [214, 224, 211, 201, 210, 221],
    203 => [219, 205, 206, 215],
    204 => [228, 223, 222, 212, 221],
    205 => [215, 203, 206, 209],
    206 => [215, 205, 209, 207],
    207 => [137, 125, 223, 232],
    209 => [213, 227, 232, 207, 206, 205, 203, 219],
    210 => [202, 201, 212, 221],
    211 => [224, 219, 201, 202],
    212 => [221, 210, 201, 215, 204],
    213 => [068, 232, 227, 209, 004, 230, 218],
    214 => [085, 229, 224, 202, 220, 235],
    215 => [222, 212, 201, 203, 205, 206],
    217 => [137, 125],
    219 => [211, 224, 230, 213, 209, 203],
    220 => [235, 214, 221],
    221 => [026, 220, 202, 210, 212],
    222 => [215, 223, 204],
    223 => [222, 204, 207, 123],
    224 => [229, 231, 219, 211, 202, 214],
    227 => [213, 209, 232],
    228 => [026, 119, 123, 204],
    229 => [085, 214, 224, 231, 081],
    230 => [054, 004, 213, 219, 231, 081],
    231 => [229, 081, 230, 224],
    232 => [068, 110, 125, 207, 227, 213, 209],
    235 => [016, 017, 220, 214, 085],
    240 => [035, 082, 081]
  }

  def zips do
    Map.keys(@connected_zips)
  end

  def score(zip, list) when is_binary(zip) and is_list(list) do
    score(zip_to_code(zip), Enum.map(list, &zip_to_code/1))
  end

  def score(_zip, []), do: 100

  @doc """
  If you are already in the same ZIP, automatic 100.

  Otherwise a score between 0 and 100 is given based on the proximity
  of your zip to the other_zips.
  """
  def score(zip, other_zips) do
    if Enum.member?(other_zips, zip) do
      100
    else
      amount =
        other_zips
        |> Enum.map(fn other_zip ->
          score = 11 - (distance(zip, other_zip) || 100)
          Enum.min([Enum.max([0, score]), 10])
        end)
        |> Enum.sum()

      div(amount * 10, length(other_zips))
    end
  end

  def zip_to_code("43" <> <<rest::binary>>) do
    String.to_integer(rest)
  end

  def zip_to_code(_), do: 999

  def distance(same_zip, same_zip), do: 0

  def distance(zip_a, zip_b) do
    ZipCodeDistanceStore.maybe_start(__MODULE__)

    ZipCodeDistanceStore.do_distance(__MODULE__, zip_a, zip_b, &build_steps/1)
  end

  def build_steps(zip) do
    do_build_steps(1, [[zip]], zip)
  end

  def do_build_steps(step, history, zip) do
    next_level_zips =
      @connected_zips
      |> Map.take(List.first(history))
      |> Enum.flat_map(fn {_, b} -> b end)
      |> Enum.uniq()

    next_level_zips = next_level_zips -- List.flatten(history)

    if next_level_zips != [] do
      Enum.each(next_level_zips, fn next_level_zip ->
        ZipCodeDistanceStore.put(__MODULE__, zip, next_level_zip, step)
      end)

      do_build_steps(step + 1, [next_level_zips | history], zip)
    end
  end
end

defmodule CurbsideConcertsWeb.ZipCodeDistanceStore do
  use GenServer

  def do_distance(name, zip_a, zip_b, build_steps_fun) do
    case get(name, zip_a, zip_b) do
      nil ->
        build_steps_fun.(zip_a)
        get(name, zip_a, zip_b)

      result ->
        result
    end
  end

  defp get(name, zip_a, zip_b) do
    GenServer.call(name, {:get, {zip_a, zip_b}})
  end

  def put(name, zip_a, zip_b, distance) do
    GenServer.call(name, {:put, {zip_b, zip_a}, distance})
    GenServer.call(name, {:put, {zip_a, zip_b}, distance})
  end

  def maybe_start(name) do
    case GenServer.start_link(__MODULE__, [], name: name) do
      {:ok, _pid} ->
        :ok

      {:error, {:already_started, _pid}} ->
        :ok
    end
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get, {zip_a, zip_b}}, _from, state) do
    {:reply, Map.get(state, {zip_a, zip_b}), state}
  end

  def handle_call({:put, {zip_a, zip_b}, value}, _from, state) do
    {:reply, :ok, Map.put(state, {zip_a, zip_b}, value)}
  end
end
