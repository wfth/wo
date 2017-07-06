defmodule Wo.SearchControllerTest do
  use Wo.ConnCase

  test "renders search results", %{conn: conn} do
    conn = get conn, search_path(conn, :index), q: "genesis"
    assert html_response(conn, 200) =~ "Search"
  end
end
