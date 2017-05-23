defmodule Wo.SermonSeriesControllerTest do
  use Wo.ConnCase

  alias Wo.SermonSeries
  @valid_attrs %{buy_graphic_key: "some content", description: "some content", graphic_key: "some content", price: "120.5", released_on_string: "4-17-2010", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sermon_series_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sermonseries"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, sermon_series_path(conn, :new)
    assert html_response(conn, 200) =~ "New sermon series"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, sermon_series_path(conn, :create), sermon_series: @valid_attrs
    assert redirected_to(conn) == sermon_series_path(conn, :index)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sermon_series_path(conn, :create), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "New sermon series"
  end

  test "shows chosen resource", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = get conn, sermon_series_path(conn, :show, sermon_series)
    assert html_response(conn, 200) =~ "Show sermon series"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sermon_series_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = get conn, sermon_series_path(conn, :edit, sermon_series)
    assert html_response(conn, 200) =~ "Edit sermon series"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = put conn, sermon_series_path(conn, :update, sermon_series), sermon_series: @valid_attrs
    assert redirected_to(conn) == sermon_series_path(conn, :show, sermon_series)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = put conn, sermon_series_path(conn, :update, sermon_series), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit sermon series"
  end

  test "deletes chosen resource", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = delete conn, sermon_series_path(conn, :delete, sermon_series)
    assert redirected_to(conn) == sermon_series_path(conn, :index)
    refute Repo.get(SermonSeries, sermon_series.id)
  end
end
