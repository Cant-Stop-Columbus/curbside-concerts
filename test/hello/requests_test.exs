defmodule Hello.RequestsTest do
  use Hello.DataCase

  alias Hello.Requests
  alias Hello.Requests.Request

  @valid_request_attrs %{
    contact_preference: "contact_requester",
    nominee_name: "Helga",
    nominee_phone: "6145557890",
    nominee_address: "123 Awesome St Columbus, OH",
    song: "Up on the Rooftop",
    special_message: "Thanks for always being there",
    requester_name: "Emma",
    requester_phone: "6145551234"
  }

  describe "state management" do
    test "create_request/1 defaults to pending" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      assert %Request{state: "pending"} = request
    end

    test "accept_request/1 makes state accepted" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      assert %Request{state: "accepted"} = request
    end

    test "enroute_request/1 makes state accepted" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      {:ok, request} = Requests.enroute_request(request)
      assert %Request{state: "enroute"} = request
    end

    test "enroute_request/1 not allowed from pending state" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      # {:ok, request} = Requests.accept_request(request)
      assert_bad_transition(Requests.enroute_request(request))
    end
  end

  def assert_bad_transition({:error, "Transition to this state isn't declared."}),
    do: assert(true)

  def assert_bad_transition(_), do: assert(false, "Expected a failed transition.")
end
