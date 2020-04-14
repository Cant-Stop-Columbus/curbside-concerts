defmodule CurbsideConcertsWeb.Helpers.RequestAddressTest do
  use ExUnit.Case

  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.Helpers.RequestAddress

  describe "full_address/1" do
    test "returns the newer address value if present" do
      nominee_address = Faker.Address.street_address()
      nominee_street_address = Faker.Address.street_address()
      nominee_city = Faker.Address.city()
      nominee_zip_code = Faker.Address.zip_code()

      request = %Request{
        nominee_street_address: nominee_street_address,
        nominee_city: nominee_city,
        nominee_zip_code: nominee_zip_code,
        nominee_address: nominee_address
      }

      full_address = RequestAddress.full_address(request)
      assert full_address == "#{nominee_street_address} #{nominee_city} #{nominee_zip_code}"
    end

    test "returns the legacy address if no newer address exists" do
      nominee_address = Faker.Address.street_address()
      full_address = RequestAddress.full_address(%Request{nominee_address: nominee_address})
      assert full_address == nominee_address
    end
  end
end
