defmodule HelloWeb.AdminControllerTest do
  use HelloWeb.ConnCase

  describe "index/2" do
    test "should render the admin index page", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))

      assert html_response(conn, 200) =~
               "Admin Page"
    end
  end
end
