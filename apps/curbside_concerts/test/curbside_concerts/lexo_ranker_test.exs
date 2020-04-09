defmodule CurbsideConcerts.LexoRankerTest do
  use ExUnit.Case

  alias CurbsideConcerts.LexoRanker, as: Ranker

  describe "empty list" do
    test "first item gets m" do
      assert Ranker.calculate(nil, nil) == "mzzzzzzz"
    end
  end

  describe "above a solo item" do
    test "above a solo m gets g" do
      assert Ranker.calculate(nil, "m") == "gzzzzzzz"
    end

    test "above a solo g gets d" do
      assert Ranker.calculate(nil, "g") == "dzzzzzzz"
    end

    test "above a solo d gets b" do
      assert Ranker.calculate(nil, "d") == "bzzzzzzz"
    end

    test "above a solo b gets a" do
      assert Ranker.calculate(nil, "b") == "azzzzzzz"
    end

    test "above a solo aamaaa gets aagzzz" do
      assert Ranker.calculate(nil, "aamaaa") == "aagzzzzz"
    end

    test "above a solo aaaaaaaa also gets aaaaaaaa" do
      assert Ranker.calculate(nil, "aaaaaaaa") == "aaaaaaaa"
    end
  end

  describe "below a solo item" do
    test "below a solo m gets s" do
      assert Ranker.calculate("m", nil) == "szzzzzzz"
    end

    test "below a solo s gets v" do
      assert Ranker.calculate("s", nil) == "vzzzzzzz"
    end

    test "below a solo v gets x" do
      assert Ranker.calculate("v", nil) == "xzzzzzzz"
    end

    test "below a solo x gets y" do
      assert Ranker.calculate("x", nil) == "yzzzzzzz"
    end

    test "below a solo y gets zm" do
      assert Ranker.calculate("y", nil) == "zmzzzzzz"
    end

    test "below a solo z gets z because we hit our limit" do
      assert Ranker.calculate("z", nil) == "zzzzzzzz"
    end
  end

  describe "between two values" do
    test "same values gives the same value" do
      assert Ranker.calculate("gggggggg", "gggggggg") == "gggggggg"
      assert Ranker.calculate("iiii", "iiii") == "iiiizzzz"
      assert Ranker.calculate("oooo", "oooozzzz") == "oooozzzz"
      assert Ranker.calculate("qqqqzzzz", "qqqq") == "qqqqzzzz"
    end

    test "aaaaaaaa - zzzzzzzz gives mzzzzzzz" do
      assert Ranker.calculate("aaaaaaaa", "zzzzzzzz") == "mzzzzzzz"
    end

    test "aaaaaaaa - mzzzzzzz gives gzzzzzzz" do
      assert Ranker.calculate("aaaaaaaa", "mzzzzzzz") == "gzzzzzzz"
    end

    test "mzzzzzzz - zzzzzzzz gives szzzzzzz" do
      assert Ranker.calculate("mzzzzzzz", "zzzzzzzz") == "szzzzzzz"
    end

    test "aaaabbbb - aaaacccc gives aaaabzzz" do
      assert Ranker.calculate("aaaabbbb", "aaaacccc") == "aaaabzzz"
    end

    test "gggggggg - gggggggi gives gggggggh" do
      assert Ranker.calculate("gggggggg", "gggggggi") == "gggggggh"
    end

    test "llllllll - lllllllm gives llllllll" do
      # sequential gives no room in between
      assert Ranker.calculate("llllllll", "lllllllm") == "llllllll"
    end
  end

  describe "ranks given in wrong order" do
    test "just give the middle anyway" do
      assert Ranker.calculate("g", "b") == "dzzzzzzz"
      assert Ranker.calculate("g", "f") == "gmzzzzzz"
      assert Ranker.calculate("mmmmczzz", "mmmmbzzz") == "mmmmcmzz"
    end
  end

  describe "ranks given are invalid" do
    test "formats out invalid characters" do
      assert Ranker.calculate("3sz9-@zk8", "0szzm2") == "szzlzzzz"
    end

    test "ignores characters beyond length allowed" do
      assert Ranker.calculate("3sz9-@zk8iiiijjjjkkkk", "0szzm2aohshhs") == "szzlzzzz"
      assert Ranker.calculate("mmmmmmmma", "mmmmmmmmz") == "mmmmmmmm"
    end
  end
end
