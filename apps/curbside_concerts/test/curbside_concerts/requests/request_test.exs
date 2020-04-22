defmodule CurbsideConcerts.Requests.RequestTest do
  use CurbsideConcerts.DataCase

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Requests.Request

  setup do
    request = build(:request, %{
      # Faker.Phone.EnUs.phone(),
      requester_phone: "7405556789",
      nominee_zip_code: "12345"
    })

    {:ok, request: request}
  end

  describe "nominee_zip_code" do
    test "only numbers allowed", %{request: request} do
      attrs = %{"nominee_zip_code" => "06810"}
      changeset = Request.changeset(request, attrs)

      assert changeset.errors == []
      assert changeset.changes.nominee_zip_code == "06810"
    end

    test "letters not allowed", %{request: request} do
      attrs = %{"nominee_zip_code" => "12345aa"}
      changeset = Request.changeset(request, attrs)

      assert changeset.errors == [{:nominee_zip_code, {"Please enter valid 5 digit zip code", []}}]
      assert changeset.changes.nominee_zip_code == "12345aa"
    end
  end

  describe "nominee_phone" do
    test "is filtered but not required", %{request: request} do
      request = %{request | nominee_phone: "7405557890"}
      attrs = %{"nominee_phone" => "(___) ___-____"}
      changeset = Request.changeset(request, attrs)
      assert changeset.errors == []
      assert changeset.changes.nominee_phone == nil
    end

    test "is filtered and can be changed", %{request: request} do
      attrs = %{"nominee_phone" => "(614) 555-1234"}
      changeset = Request.changeset(request, attrs)
      assert changeset.errors == []
      assert changeset.changes.nominee_phone == "6145551234"
    end
  end

  describe "requester_phone" do
    test "is required", %{request: request} do
      attrs = %{"requester_phone" => "(___) ___-____"}
      changeset = Request.changeset(request, attrs)

      assert changeset.errors == [
               {:requester_phone, {"Please provide an answer", [validation: :required]}}
             ]

      assert changeset.changes == %{}
    end

    test "a partial answer is not ok", %{request: request} do
      attrs = %{"requester_phone" => "(614) 555-123_"}
      changeset = Request.changeset(request, attrs)

      assert changeset.errors == [
               {:requester_phone, {"Please complete this phone number", []}}
             ]

      assert changeset.changes.requester_phone == "614555123"
    end

    test "allows a good phone number", %{request: request} do
      attrs = %{"requester_phone" => "(614) 555-1234"}
      changeset = Request.changeset(request, attrs)

      assert changeset.errors == []
      assert changeset.changes.requester_phone == "6145551234"
    end
  end
end
