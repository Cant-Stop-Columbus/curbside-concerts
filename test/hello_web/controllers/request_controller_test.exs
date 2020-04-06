defmodule HelloWeb.RequestControllerTest do
  import HelloWeb.Factory

  use HelloWeb.ConnCase

  describe "home/2" do
    test "should show the landing page", %{conn: conn} do
      html =
        conn
        |> get(Routes.request_path(conn, :home))
        |> html_response(200)

      assert html =~
               "Send a live curbside concert, for your quarantined loved ones"
    end

    test "should show the session cards", %{conn: conn} do
      # faker 2 musicians with sessions
      insert!(:session)
      insert!(:session)

      session_cards =
        conn
        |> get(Routes.request_path(conn, :home))
        |> html_response(200)
        |> Floki.find(".session-cards .session-card")

      assert length(session_cards) == 2
    end
  end

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
          contact_preference: "call_nominee",
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
