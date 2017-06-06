defmodule Wo.SearchControllerTest do
  use Wo.ConnCase

  test "renders form for searching", %{conn: conn} do
    conn = get conn, search_path(conn, :index)
    assert html_response(conn, 200) =~ "Search"
  end

  test "renders search results", %{conn: conn} do
    conn = post conn, search_path(conn, :search), search: %{search_term: "genesis"}
    assert html_response(conn, 200) =~ "Search"
  end
end
