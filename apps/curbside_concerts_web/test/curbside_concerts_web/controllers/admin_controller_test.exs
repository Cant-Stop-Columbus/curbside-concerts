defmodule CurbsideConcertsWeb.AdminControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  describe "index/2" do
    test "should render the admin index page", %{conn: conn} do
      html =
        conn
        |> get(Routes.admin_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Admin Page" == html |> Floki.find("h1") |> Floki.text()
    end
  end
end
