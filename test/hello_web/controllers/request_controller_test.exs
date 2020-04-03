defmodule HelloWeb.RequestControllerTest do
  use HelloWeb.ConnCase

  describe "new/2" do
    test "should render the new request form", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :new))

      assert html_response(conn, 200) =~
               "Live pickup truck concert, for your quarantined loved ones"
    end
  end

  describe "create/2" do
    test "redirects to confirmation when data is valid", %{conn: conn} do
      %{nominee_name: nominee_name} =
        valid_attrs = %{
          nominee_name: Faker.Name.name(),
          nominee_phone: Faker.Phone.EnUs.phone(),
          nominee_address: Faker.Address.street_address(),
          song: Faker.String.base64(),
          special_message: Faker.StarWars.quote(),
          requester_name: Faker.Name.name(),
          requester_phone: Faker.Phone.EnUs.phone()
        }

      conn = post(conn, Routes.request_path(conn, :create), request: valid_attrs)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.request_path(conn, :new)

      conn = get(conn, Routes.request_path(conn, :new))

      assert html_response(conn, 200) =~
               "Thank you for submitting a concert request for #{nominee_name}!"
    end

    test "displays error message when data is invalid", %{conn: conn} do
      invalid_attrs = %{}

      conn = post(conn, Routes.request_path(conn, :create), request: invalid_attrs)

      assert html_response(conn, 200) =~
               "Live pickup truck concert, for your quarantined loved ones"

      assert html_response(conn, 200) =~
               "Oops! Looks like a field is missing - please check below and try again"
    end
  end
end
