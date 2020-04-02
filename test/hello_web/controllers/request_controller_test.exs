defmodule HelloWeb.RequestControllerTest do
  use HelloWeb.ConnCase

  describe "new/2" do
    test "should render the new request form", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :new))
      assert html_response(conn, 200) =~ "Whatever this page says"
    end
  end
end
