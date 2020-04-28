defmodule CurbsideConcertsWeb.Helpers.HostPathTest do
  use ExUnit.Case

  alias CurbsideConcertsWeb.TrackerCypher
  alias CurbsideConcertsWeb.Helpers.HostPath

  describe "tracker_url/1" do
    test "returns the tracker url with the tracker id" do
      expected_tracker_id = TrackerCypher.encode(40)
      tracker_url = HostPath.tracker_url(40)

      assert tracker_url =~ "/tracker"
      assert tracker_url =~ expected_tracker_id
    end
  end
end
