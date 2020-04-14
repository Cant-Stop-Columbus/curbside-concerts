defmodule CurbsideConcertsWeb.TipsControllerTest do
  use CurbsideConcertsWeb.ConnCase, async: true

  describe "index/2" do
    test "should render the index view", %{conn: conn} do
      conn = get(conn, Routes.tips_path(conn, :index))
      assert html_response(conn, 200) =~ "Tip your curbside musician"
    end
  end
end
