defmodule CurbsideConcertsWeb.TipsControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  describe "index/2" do
    test "should render the index view", %{conn: conn} do
      html =
        conn
        |> get(Routes.tips_path(conn, :index))
        |> html_response(200)
        |> Floki.parse_document!()

      assert "Tip your curbside musician" == html |> Floki.find("h1") |> Floki.text()
    end
  end
end
