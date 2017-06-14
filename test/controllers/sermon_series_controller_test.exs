defmodule Wo.SermonSeriesControllerTest do
  use Wo.ConnCase

  alias Wo.SermonSeries
  @valid_attrs %{description: "some content", passages: "some content", price: 120.5, title: "some content"}
  @invalid_attrs %{title: ""}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sermon_series_path(conn, :index)
    assert html_response(conn, 200) =~ "Sermon Series"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, sermon_series_path(conn, :new)
    assert html_response(conn, 200) =~ "New Sermon Series"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, sermon_series_path(conn, :create), sermon_series: @valid_attrs
    assert redirected_to(conn) == sermon_series_path(conn, :index)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sermon_series_path(conn, :create), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "New Sermon Series"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sermon_series_sermon_path(conn, :index, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = get conn, sermon_series_path(conn, :edit, sermon_series)
    assert html_response(conn, 200) =~ "Edit Sermon Series"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = put conn, sermon_series_path(conn, :update, sermon_series), sermon_series: @valid_attrs
    assert redirected_to(conn) == sermon_series_path(conn, :index)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = put conn, sermon_series_path(conn, :update, sermon_series), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Sermon Series"
  end

  test "deletes chosen resource", %{conn: conn} do
    sermon_series = Repo.insert! %SermonSeries{}
    conn = delete conn, sermon_series_path(conn, :delete, sermon_series)
    assert redirected_to(conn) == sermon_series_path(conn, :index)
    refute Repo.get(SermonSeries, sermon_series.id)
  end
end
