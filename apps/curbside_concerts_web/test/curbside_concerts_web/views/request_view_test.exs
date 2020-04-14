defmodule CurbsideConcertsWeb.RequestViewTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.RequestView

  import CurbsideConcerts.Factory

  describe "display_state/1" do
    test "should return pending state message" do
      assert RequestView.pending_message() == RequestView.display_state(Requests.pending_state())
    end

    test "should return accepted state message" do
      assert RequestView.accepted_message() ==
               RequestView.display_state(Requests.accepted_state())
    end

    test "should return enroute state message" do
      assert RequestView.enroute_message() == RequestView.display_state(Requests.enroute_state())
    end

    test "should return arrived state message" do
      assert RequestView.arrived_message() == RequestView.display_state(Requests.arrived_state())
    end

    test "should return completed state message" do
      assert RequestView.completed_message() ==
               RequestView.display_state(Requests.completed_state())
    end

    test "should return canceled state message" do
      assert RequestView.canceled_message() ==
               RequestView.display_state(Requests.canceled_state())
    end

    test "should return offmission state message" do
      assert RequestView.offmission_message() ==
               RequestView.display_state(Requests.offmission_state())
    end

    test "should return unknown state message" do
      assert RequestView.unknown_message() ==
               RequestView.display_state("something unexpected")
    end

    test "should return state from request struct" do
      request =
        build(:request, %{
          state: Requests.arrived_state()
        })

      assert RequestView.arrived_message() == RequestView.display_state(request)
    end

    test "should return unknown message from anything else" do
      assert RequestView.unknown_message() == RequestView.display_state(3)
    end

    test "[legacy] should return unknown message from request without state" do
      request =
        %Request{}
        |> Map.delete(:state)

      assert RequestView.unknown_message() == RequestView.display_state(request)
    end
  end
end
