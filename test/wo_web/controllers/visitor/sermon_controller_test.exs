defmodule WoWeb.VisitorSermonControllerTest do
  use WoWeb.ConnCase

  @valid_attrs %{description: "some content", passages: "some content", price: 120, title: "some content", uuid: "some content"}

  setup do
    sermon_series = insert_sermon_series(@valid_attrs)
    sermon = insert_sermon(sermon_series, @valid_attrs)
    {:ok, conn: build_conn(), sermon: sermon}
  end

  test "shows chosen resource", %{conn: conn, sermon: sermon} do
    conn = get conn, sermon_path(conn, :show, sermon)
    assert html_response(conn, 200) =~ sermon.title
  end
end
