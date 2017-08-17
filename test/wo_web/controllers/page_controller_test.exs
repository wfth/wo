defmodule WoWeb.PageControllerTest do
  use WoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Wisdom for the Heart"
  end
end
