defmodule CurbsideConcertsWeb.Helpers.RequestAddressTest do
  use ExUnit.Case
  
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.Helpers.RequestAddress

  setup do
    request = %Request{ 
      nominee_street_address: Faker.Address.street_address(),
      nominee_city: Faker.Address.city(),
      nominee_zip_code: Faker.Address.zip_code()}

    %{request: request}
  end

  describe "full_address/1" do
    test "returns the legacy address value", %{request: request} do
      nominee_address = Faker.Address.street_address()
      request_with_legacy = %{request | nominee_address: nominee_address}
      full_address = RequestAddress.full_address(request_with_legacy)
      assert full_address == nominee_address
    end

    test "returns the full address", %{request: request} do
      %Request{nominee_street_address: nominee_street_address, 
        nominee_city: nominee_city, 
        nominee_zip_code: nominee_zip_code} = request
      full_address = RequestAddress.full_address(request)
      assert full_address == "#{nominee_street_address} #{nominee_city} #{nominee_zip_code}"
    end
  end
end
