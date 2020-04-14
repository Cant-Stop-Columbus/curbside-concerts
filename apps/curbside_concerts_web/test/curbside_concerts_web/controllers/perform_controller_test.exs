defmodule CurbsideConcertsWeb.PerformControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  describe "index/2" do
    test "should render the index view", %{conn: conn} do
      html =
        conn
        |> get(Routes.perform_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Are you an artist interested in performing?" ==
               html |> Floki.find("h1") |> Floki.text()
    end
  end
end
