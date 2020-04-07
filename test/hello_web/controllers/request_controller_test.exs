defmodule HelloWeb.RequestControllerTest do
  use HelloWeb.ConnCase, async: true

  import HelloWeb.Factory

  alias Hello.Musicians.Session

  describe "new/2" do
    test "should render the new request form", %{conn: conn} do
      %Session{id: session_id} =
        insert!(:session,
          name: "Jamboree Spectacular!",
          description: "You should come. It will be fun."
        )

      html =
        conn
        |> get(Routes.request_path(conn, :new, session_id))
        |> html_response(200)
        |> Floki.parse_document!()

      title =
        html
        |> Floki.find("h2")
        |> Floki.text()

      assert title == "Jamboree Spectacular!"
    end
  end

  describe "create/2" do
    test "redirects to confirmation when data is valid", %{conn: conn} do
      insert!(:session)

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
      assert redirected_to(conn) == Routes.landing_path(conn, :index)

      html =
        conn
        |> get(Routes.landing_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      success_message =
        html
        |> Floki.find(".alert-info")
        |> Floki.text()

      assert success_message ==
               "Thank you for submitting a concert request for #{nominee_name}!"
    end

    test "displays error message when data is invalid", %{conn: conn} do
      %Session{id: session_id, name: session_name} = insert!(:session)

      invalid_attrs = %{
        session_id: session_id
      }

      html =
        conn
        |> post(Routes.request_path(conn, :create), request: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      header =
        html
        |> Floki.find("h2")
        |> Floki.text()

      assert header == session_name

      error_message =
        html
        |> Floki.find(".alert-danger")
        |> Floki.text()

      assert error_message ==
               "Oops! Looks like a field is missing - please check below and try again"
    end
  end
end
