defmodule CurbsideConcerts.RequestsTest do
  use CurbsideConcerts.DataCase

  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request

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

  describe "create_request/1 state management" do
    test "create_request/1 defaults to pending" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      assert %Request{state: "pending"} = request
    end
  end

  describe "accept_request/1" do
    test "transitions to state accepted" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      assert %Request{state: "accepted"} = request
    end
  end

  describe "enroute_request/1" do
    test "transitions to state accepted" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      {:ok, request} = Requests.enroute_request(request)
      assert %Request{state: "enroute"} = request
    end

    test "transition not allowed from pending state" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      assert_bad_transition(Requests.enroute_request(request))
    end
  end

  describe "arrived_request/1" do
    test "transition allowed from enroute" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      {:ok, request} = Requests.enroute_request(request)
      {:ok, request} = Requests.arrived_request(request)
      assert %Request{state: "arrived"} = request
    end

    test "transition not allowed from pending state" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      assert_bad_transition(Requests.arrived_request(request))
    end
  end

  describe "complete_request/1" do
    test "transition allowed from enroute" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      {:ok, request} = Requests.enroute_request(request)
      {:ok, request} = Requests.arrived_request(request)
      {:ok, request} = Requests.complete_request(request)
      assert %Request{state: "completed"} = request
    end

    test "transition not allowed from pending state" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      assert_bad_transition(Requests.complete_request(request))
    end
  end

  describe "cancel_request/1" do
    test "transition allowed from pending" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.cancel_request(request)
      assert %Request{state: "canceled"} = request
    end

    test "transition allowed from accepted" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.accept_request(request)
      {:ok, request} = Requests.cancel_request(request)
      assert %Request{state: "canceled"} = request
    end
  end

  describe "archive_request/1" do
    test "transition allowed from pending" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.archive_request(request)
      assert %Request{state: "archived"} = request
    end

    test "transition allowed from canceled" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.cancel_request(request)
      {:ok, request} = Requests.archive_request(request)
      assert %Request{state: "archived"} = request
    end
  end

  describe "back_to_pending_request/1" do
    test "transition allowed from pending (the same)" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.back_to_pending_request(request)
      assert %Request{state: "pending"} = request
    end

    test "transition allowed from canceled" do
      {:ok, request} = Requests.create_request(@valid_request_attrs)
      {:ok, request} = Requests.cancel_request(request)
      {:ok, request} = Requests.back_to_pending_request(request)
      assert %Request{state: "pending"} = request
    end
  end

  def assert_bad_transition({:error, "Transition to this state isn't declared."}),
    do: assert(true)

  def assert_bad_transition(_), do: assert(false, "Expected a failed transition.")
end
