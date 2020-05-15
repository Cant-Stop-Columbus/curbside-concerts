defmodule CurbsideConcertsWeb.MusicianControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: false

  import CurbsideConcerts.Factory
  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Musicians.Musician

  setup %{conn: conn} do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end

  describe "new/2" do
    test "should render the new musician form", %{conn: conn} do
      html =
        conn
        |> get(Routes.musician_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      title =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert title == "New Musician"
    end
  end

  describe "create/2" do
    test "redirects back to the index page if the musician was created", %{conn: conn} do
      conn = post(conn, Routes.musician_path(conn, :create), musician: attrs(:musician))

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.musician_path(conn, :index)

      html =
        conn
        |> get(Routes.musician_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      success_message =
        html
        |> Floki.find(".alert-info")
        |> Floki.text()

      assert success_message == "Musician added!"
    end

    test "displays error message when data is invalid", %{conn: conn} do
      invalid_attrs = %{}

      html =
        conn
        |> post(Routes.musician_path(conn, :create), musician: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      header =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert header == "New Musician"

      error_message =
        html
        |> Floki.find(".alert-danger")
        |> Floki.text()

      assert error_message == "Oops! Looks like a field is missing - please check below and try again"
    end
  end

  describe "show/2" do
    test "renders selected musician", %{conn: conn} do
      %Musician{name: name} = musician = insert!(:musician)

      html =
        conn
        |> get(Routes.musician_path(conn, :show, musician))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Musician" == html |> Floki.find("h1") |> Floki.text()
      assert html |> Floki.text() =~ name
    end
  end

  describe "edit/2" do
    test "renders form for editing a musician", %{conn: conn} do
      musician = insert!(:musician)

      html =
        conn
        |> get(Routes.musician_path(conn, :edit, musician))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Musician" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "update/2" do
    test "redirects back to the view musician page when update is valid", %{conn: conn} do
      musician = insert!(:musician)

      update_attrs = %{
        name: "new name"
      }

      conn = put(conn, Routes.musician_path(conn, :update, musician), musician: update_attrs)
      assert redirected_to(conn) == Routes.musician_path(conn, :show, musician)

      html =
        conn
        |> get(Routes.musician_path(conn, :show, musician))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Musician" == html |> Floki.find("h1") |> Floki.text()
      assert "Musician updated successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      musician = insert!(:musician)

      invalid_attrs = %{
        name: nil
      }

      html =
        conn
        |> put(Routes.musician_path(conn, :update, musician), musician: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Musician" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "artists/2" do
    test "renders all of the musicians", %{conn: conn} do
      %Musician{name: first_musician_name} = insert!(:musician)
      %Musician{name: second_musician_name} = insert!(:musician)
      
      html =
        conn
        |> get(Routes.musician_path(conn, :artists))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Tip your curbside musician" == html |> Floki.find("h1") |> Floki.text()
      
      assert html |> Floki.text() =~ first_musician_name
      assert html |> Floki.text() =~ second_musician_name
    end
  end
end
