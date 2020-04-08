defmodule CurbsideConcertsWeb.LandingControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  alias CurbsideConcerts.Musicians.Session

  import CurbsideConcertsWeb.Factory

  describe "index/2" do
    test "should show the landing page", %{conn: conn} do
      html =
        conn
        |> get(Routes.landing_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      header =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert header ==
               "Know someone feeling down?"
    end

    test "should show the session cards", %{conn: conn} do
      %Session{name: first_session_name} = insert!(:session)
      %Session{name: second_session_name} = insert!(:session)

      session_cards =
        conn
        |> get(Routes.landing_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()
        |> Floki.find(".session-cards .session-card")

      assert length(session_cards) >= 2
      assert session_cards |> Floki.text() |> String.contains?(first_session_name)
      assert session_cards |> Floki.text() |> String.contains?(second_session_name)
    end
  end
end
