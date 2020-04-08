defmodule CurbsideConcertsWeb.LandingControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

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
  end
end
