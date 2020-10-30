defmodule CurbsideConcertsWeb.RequestControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: false

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Requests.Request

  import CurbsideConcerts.Factory

  describe "view/2" do
    setup [:auth_user]

    test "renders selected request", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      html =
        conn
        |> get(Routes.request_path(conn, :show, request))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Request" == html |> Floki.find("h1") |> Floki.text()
      assert html |> Floki.text() =~ special_message
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
        |> Floki.parse_document!()

      assert "Edit Request" == html |> Floki.find("h1") |> Floki.text()
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
        |> Floki.parse_document!()

      assert "View Request" == html |> Floki.find("h1") |> Floki.text()
      assert "Request updated successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      request = insert!(:request)

      invalid_attrs = %{
        nominee_street_address: nil
      }

      html =
        conn
        |> put(Routes.request_path(conn, :update, request), request: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Request" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "archive/2" do
    setup [:auth_user]

    test "archives request", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ special_message

      redirect = Routes.request_path(conn, :index)

      conn = put(conn, Routes.request_path(conn, :archive, request, %{redirect: redirect}))
      assert redirected_to(conn) == Routes.request_path(conn, :index)

      html =
        conn
        |> get(Routes.request_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Request archived successfully." == html |> Floki.find(".alert-info") |> Floki.text()
      refute special_message =~ html |> Floki.text()
    end
  end

  describe "state/2" do
    setup [:auth_user]

    test "should update state to offmission", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      conn = get(conn, Routes.request_path(conn, :index))

      assert conn |> html_response(200) |> Floki.parse_document!() |> Floki.text() =~
               special_message

      redirect = Routes.request_path(conn, :index, %{state: "offmission"})

      conn =
        put(conn, Routes.request_path(conn, :state, request, "offmission", %{redirect: redirect}))

      assert redirected_to(conn) == redirect

      html =
        conn
        |> get(redirect)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Request state updated successfully." ==
               html |> Floki.find(".alert-info") |> Floki.text()

      assert html |> Floki.text() =~ special_message
    end

    test "should update state to pending", %{conn: conn} do
      %Request{special_message: special_message} = request = insert!(:request)

      conn = get(conn, Routes.request_path(conn, :index))

      assert conn |> html_response(200) |> Floki.parse_document!() |> Floki.text() =~
               special_message

      redirect = Routes.request_path(conn, :index, %{state: "pending"})

      conn =
        put(conn, Routes.request_path(conn, :state, request, "pending", %{redirect: redirect}))

      assert redirected_to(conn) == redirect

      html =
        conn
        |> get(redirect)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Request state updated successfully." ==
               html |> Floki.find(".alert-info") |> Floki.text()

      assert html |> Floki.text() =~ special_message
    end
  end

  describe "disclaimer/2" do
    test "renders the disclaimer page", %{conn: conn} do
      html =
        conn
        |> get(Routes.request_path(conn, :disclaimer))
        |> html_response(200)
        |> Floki.parse_document!()

      title =
        html
        |> Floki.find("h2")
        |> Floki.text()

      assert title == "Disclaimer"
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
