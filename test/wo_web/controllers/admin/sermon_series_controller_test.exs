defmodule WoWeb.AdminSermonSeriesControllerTest do
  use WoWeb.ConnCase

  alias Wo.Resource
  alias Wo.Resource.SermonSeries
  alias Wo.Account
  alias WoWeb.Session

  @administrator_attrs %{first_name: "Test", last_name: "Dude", email: "tester@dude.com", password: "testing123", administrator: true}
  @valid_attrs %{description: "some content", passages: "some content", price: 120, title: "some content", uuid: "some content"}
  @invalid_attrs %{title: ""}

  setup tags do
    {:ok, user} = Account.create_user(@administrator_attrs)

    conn = build_conn() |> init_test_session(%{})
    {:ok, logged_in_conn} = Session.login(conn, %{email: user.email, password: user.password})

    if tags[:insert_sermon_series] do
      {:ok, sermon_series} = Resource.create_sermon_series(@valid_attrs)
      {:ok, conn: logged_in_conn, sermon_series: sermon_series}
    else
      {:ok, conn: logged_in_conn}
    end
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_sermon_series_path(conn, :index)
    assert html_response(conn, 200) =~ "Sermon Series"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_sermon_series_path(conn, :new)
    assert html_response(conn, 200) =~ "New Sermon Series"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_sermon_series_path(conn, :create), sermon_series: @valid_attrs
    assert redirected_to(conn) == admin_sermon_series_path(conn, :index)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_sermon_series_path(conn, :create), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "New Sermon Series"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_sermon_series_sermon_path(conn, :index, -1)
    end
  end

  @tag :insert_sermon_series
  test "renders form for editing chosen resource", %{conn: conn, sermon_series: sermon_series} do
    conn = get conn, admin_sermon_series_path(conn, :edit, sermon_series)
    assert html_response(conn, 200) =~ "Edit Sermon Series"
  end

  @tag :insert_sermon_series
  test "updates chosen resource and redirects when data is valid", %{conn: conn, sermon_series: sermon_series} do
    conn = put conn, admin_sermon_series_path(conn, :update, sermon_series), sermon_series: @valid_attrs
    assert redirected_to(conn) == admin_sermon_series_path(conn, :index)
    assert Repo.get_by(SermonSeries, @valid_attrs)
  end

  @tag :insert_sermon_series
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, sermon_series: sermon_series} do
    conn = put conn, admin_sermon_series_path(conn, :update, sermon_series), sermon_series: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Sermon Series"
  end

  @tag :insert_sermon_series
  test "deletes chosen resource", %{conn: conn, sermon_series: sermon_series} do
    conn = delete conn, admin_sermon_series_path(conn, :delete, sermon_series)
    assert redirected_to(conn) == admin_sermon_series_path(conn, :index)
    refute Repo.get(SermonSeries, sermon_series.id)
  end
end
