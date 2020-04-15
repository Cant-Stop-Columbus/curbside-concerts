defmodule CurbsideConcertsWeb.SessionControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Musicians.Session

  setup %{conn: conn} do
    %User{} = user = insert!(:user)

    conn =
      conn
      |> with_authenticated_user(user)

    %{conn: conn}
  end

  describe "index" do
    test "lists all active sessions", %{conn: conn} do
      %Session{name: active_session_name} =
        insert!(:session, %{
          archived: false
        })

      %Session{name: archived_session_name} =
        insert!(:session, %{
          archived: true
        })

      html =
        conn
        |> get(Routes.session_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Sessions" == html |> Floki.find("h1") |> Floki.text()
      assert html |> Floki.text() =~ active_session_name
      refute html |> Floki.text() =~ archived_session_name
    end

    test "lists all archived sessions", %{conn: conn} do
      %Session{name: active_session_name} =
        insert!(:session, %{
          archived: false
        })

      %Session{name: archived_session_name} =
        insert!(:session, %{
          archived: true
        })

      html =
        conn
        |> get(Routes.session_path(conn, :index, %{"archived" => "true"}))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Archived Sessions" == html |> Floki.find("h1") |> Floki.text()
      refute html |> Floki.text() =~ active_session_name
      assert html |> Floki.text() =~ archived_session_name
    end
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      html =
        conn
        |> get(Routes.session_path(conn, :new))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "New Session" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "create session" do
    test "redirects to show when data is valid", %{conn: conn} do
      create_attrs = attrs(:session)

      conn = post(conn, Routes.session_path(conn, :create), session: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.session_path(conn, :show, id)

      html =
        conn
        |> get(Routes.session_path(conn, :show, id))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Session" == html |> Floki.find("h1") |> Floki.text()
      assert "Session created successfully." == html |> Floki.find(".alert-info") |> Floki.text()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{}

      html =
        conn
        |> post(Routes.session_path(conn, :create), session: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "New Session" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "edit session" do
    test "renders form for editing chosen session", %{conn: conn} do
      session = insert!(:session)

      html =
        conn
        |> get(Routes.session_path(conn, :edit, session))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Session" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "update session" do
    test "redirects when data is valid", %{conn: conn} do
      session = insert!(:session)

      update_attrs = %{
        name: "updated name"
      }

      conn = put(conn, Routes.session_path(conn, :update, session), session: update_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :show, session)

      html =
        conn
        |> get(Routes.session_path(conn, :show, session))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "View Session" == html |> Floki.find("h1") |> Floki.text()
      assert "Session updated successfully." == html |> Floki.find(".alert-info") |> Floki.text()
      assert html |> Floki.text() =~ "updated name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      session = insert!(:session)

      invalid_attrs = %{name: nil}

      html =
        conn
        |> put(Routes.session_path(conn, :update, session), session: invalid_attrs)
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Edit Session" == html |> Floki.find("h1") |> Floki.text()
    end
  end

  describe "archive/2" do
    test "archives session", %{conn: conn} do
      %Session{name: name} = session = insert!(:session)

      conn = get(conn, Routes.session_path(conn, :index))
      assert conn |> html_response(200) |> Floki.parse_document!() |> Floki.text() =~ name

      conn = put(conn, Routes.session_path(conn, :archive, session))
      assert redirected_to(conn) == Routes.session_path(conn, :index)

      html =
        conn
        |> get(Routes.session_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Session archived successfully." == html |> Floki.find(".alert-info") |> Floki.text()
      refute html |> Floki.text() =~ name
    end
  end
end
