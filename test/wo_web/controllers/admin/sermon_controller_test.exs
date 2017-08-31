defmodule WoWeb.AdminSermonControllerTest do
  use WoWeb.ConnCase

  alias Wo.Resource.Sermon
  alias Wo.Account
  alias WoWeb.Session

  @administrator_attrs %{first_name: "Test", last_name: "Dude", email: "tester@dude.com", password: "testing123", administrator: true}
  @valid_attrs %{description: "some content", passages: "some content", price: 120, title: "some content", uuid: "some content"}
  @invalid_attrs %{title: ""}

  setup do
    {:ok, user} = Account.create_user(@administrator_attrs)

    conn = build_conn() |> init_test_session(%{})
    {:ok, logged_in_conn} = Session.login(conn, %{email: user.email, password: user.password})

    sermon_series = insert_sermon_series(@valid_attrs)
    {:ok, conn: logged_in_conn, sermon_series: sermon_series}
  end

  test "lists all entries on index", %{conn: conn, sermon_series: series} do
    conn = get conn, admin_sermon_series_sermon_path(conn, :index, series)
    assert html_response(conn, 200) =~ "Sermons"
  end

  test "renders form for new resources", %{conn: conn, sermon_series: series} do
    conn = get conn, admin_sermon_series_sermon_path(conn, :new, series)
    assert html_response(conn, 200) =~ "New sermon"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, sermon_series: series} do
    conn = post conn, admin_sermon_series_sermon_path(conn, :create, series), sermon: @valid_attrs
    assert redirected_to(conn) == admin_sermon_series_sermon_path(conn, :index, series)
    assert Repo.get_by(Sermon, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, sermon_series: series} do
    conn = post conn, admin_sermon_series_sermon_path(conn, :create, series), sermon: @invalid_attrs
    assert html_response(conn, 200) =~ "New sermon"
  end

  test "shows chosen resource", %{conn: conn, sermon_series: series} do
    sermon = insert_sermon(series, @valid_attrs)
    conn = get conn, admin_sermon_series_sermon_path(conn, :show, series, sermon)
    assert html_response(conn, 200) =~ "Show sermon"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, sermon_series: series} do
    assert_error_sent 404, fn ->
      get conn, admin_sermon_series_sermon_path(conn, :show, series, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, sermon_series: series} do
    sermon = insert_sermon(series, @valid_attrs)
    conn = get conn, admin_sermon_series_sermon_path(conn, :edit, series, sermon)
    assert html_response(conn, 200) =~ "Edit sermon"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, sermon_series: series} do
    sermon = insert_sermon(series, @valid_attrs)
    conn = put conn, admin_sermon_series_sermon_path(conn, :update, series, sermon), sermon: @valid_attrs
    assert redirected_to(conn) == admin_sermon_series_sermon_path(conn, :show, series, sermon)
    assert Repo.get_by(Sermon, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, sermon_series: series} do
    sermon = insert_sermon(series, @valid_attrs)
    conn = put conn, admin_sermon_series_sermon_path(conn, :update, series, sermon), sermon: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit sermon"
  end

  test "deletes chosen resource", %{conn: conn, sermon_series: series} do
    sermon = insert_sermon(series, @valid_attrs)
    conn = delete conn, admin_sermon_series_sermon_path(conn, :delete, series, sermon)
    assert redirected_to(conn) == admin_sermon_series_sermon_path(conn, :index, series)
    refute Repo.get(Sermon, sermon.id)
  end
end
