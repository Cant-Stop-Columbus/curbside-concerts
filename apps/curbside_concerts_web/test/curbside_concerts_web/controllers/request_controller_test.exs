defmodule CurbsideConcertsWeb.RequestControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: false

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Requests
  alias CurbsideConcerts.Requests.Request
  alias CurbsideConcertsWeb.TrackerCypher

  import CurbsideConcerts.Factory

  describe "new/2" do
    test "should render the new request form", %{conn: conn} do
      html =
        conn
        |> get(Routes.request_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      title =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert title == "Request a concert"
    end
  end

  describe "create/2" do
    test "redirects to tracker confirmation when data is valid", %{conn: conn} do
      %{nominee_name: nominee_name} =
        valid_attrs = %{
          nominee_name: Faker.Name.name(),
          contact_preference: "call_nominee",
          nominee_phone: Faker.Phone.EnUs.phone(),
          nominee_address: Faker.Address.street_address(),
          song: Faker.String.base64(),
          special_message: Faker.StarWars.quote(),
          requester_name: Faker.Name.name(),
          requester_phone: Faker.Phone.EnUs.phone(),
          requester_email: Faker.Internet.email()
        }

      conn = post(conn, Routes.request_path(conn, :create), request: valid_attrs)
      %Request{id: request_id} = Requests.all_requests() |> List.first()
      tracker_id = TrackerCypher.encode(request_id)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.request_path(conn, :tracker, tracker_id)

      html =
        conn
        |> get(Routes.request_path(conn, :tracker, tracker_id))
        |> html_response(200)
        |> Floki.parse_document!()

      success_message =
        html
        |> Floki.find(".alert-info")
        |> Floki.text()

      assert success_message ==
               "Thank you for submitting a concert request for #{nominee_name}! Please bookmark this page to track its progress."
    end

    test "displays error message when data is invalid", %{conn: conn} do
      invalid_attrs = %{}

      html =
        conn
        |> post(Routes.request_path(conn, :create), request: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      header =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert header == "Request a concert"

      error_message =
        html
        |> Floki.find(".alert-danger")
        |> Floki.text()

      assert error_message ==
               "Oops! Looks like a field is missing - please check below and try again"
    end
  end

  describe "cancel_request/2" do
    test "cancels a request", %{conn: conn} do
      %Request{nominee_name: nominee_name, id: request_id} = insert!(:request)
      tracker_id = TrackerCypher.encode(request_id)

      conn = put(conn, Routes.request_path(conn, :cancel_request, tracker_id))
      assert Routes.request_path(conn, :new) == redirected_to(conn)

      html =
        conn
        |> get(Routes.request_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      success_message =
        html
        |> Floki.find(".alert-info")
        |> Floki.text()

      assert success_message == "The concert request for #{nominee_name} has been cancelled."
    end

    test "redirects to new with failure message when request is not found", %{conn: conn} do
      tracker_id = "invalid-tracker"

      conn = put(conn, Routes.request_path(conn, :cancel_request, tracker_id))
      redir_path = redirected_to(conn)
      assert Routes.request_path(conn, :new) == redir_path

      html =
        recycle(conn)
        |> get(redir_path)
        |> html_response(200)
        |> Floki.parse_document!()

      failure_message =
        html
        |> Floki.find(".alert-danger")
        |> Floki.text()

      assert failure_message == "The concert request was not found."
    end
  end

  describe "view/2" do
    setup [:auth_user]

    test "renders selected request", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      html =
        conn
        |> get(Routes.request_path(conn, :show, request))
        |> html_response(200)

      assert html =~ "View Request"
      assert html =~ special_message
    end
  end

  describe "edit/2" do
    setup [:auth_user]

    test "renders form for editing chosen request", %{conn: conn} do
      request = insert!(:request)

      html =
        conn
        |> get(Routes.request_path(conn, :edit, request))
        |> html_response(200)

      assert html =~ "Edit Request"
    end
  end

  describe "update/2" do
    setup [:auth_user]

    test "redirects when data is valid", %{conn: conn} do
      request = insert!(:request)

      update_attrs = %{
        nominee_address: "updated address"
      }

      conn = put(conn, Routes.request_path(conn, :update, request), request: update_attrs)
      assert redirected_to(conn) == Routes.request_path(conn, :show, request)

      html =
        conn
        |> get(Routes.request_path(conn, :show, request))
        |> html_response(200)

      assert html =~ "View Request"

      assert html =~ "Request updated successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      request = insert!(:request)

      invalid_attrs = %{
        nominee_address: nil
      }

      conn = put(conn, Routes.request_path(conn, :update, request), request: invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Request"
    end
  end

  describe "archive/2" do
    setup [:auth_user]

    test "archives request", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ special_message

      conn = put(conn, Routes.request_path(conn, :archive, request))
      assert redirected_to(conn) == Routes.request_path(conn, :index)

      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ "Request archived successfully."
      refute html_response(conn, 200) =~ special_message
    end
  end

  def auth_user(%{conn: conn}) do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end
end
