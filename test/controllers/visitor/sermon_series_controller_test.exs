defmodule WoWeb.VisitorSermonSeriesControllerTest do
  use WoWeb.ConnCase

  @valid_attrs %{description: "some content", passages: "some content", price: 120.5, title: "some content", uuid: "some content"}

  setup tags do
    if tags[:insert_sermon_series] do
      sermon_series = insert_sermon_series(@valid_attrs)
      {:ok, conn: build_conn(), sermon_series: sermon_series}
    else
      {:ok, conn: build_conn()}
    end
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sermon_series_path(conn, :index)
    assert html_response(conn, 200) =~ "Sermon Series"
  end

  @tag :insert_sermon_series
  test "shows chosen resource", %{conn: conn, sermon_series: series} do
    conn = get conn, sermon_series_path(conn, :show, series)
    assert html_response(conn, 200) =~ series.title
  end
end
