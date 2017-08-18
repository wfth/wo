defmodule WoWeb.SessionControllerTest do
  use WoWeb.ConnCase

  alias Wo.Account
  alias WoWeb.Session

  @valid_params %{first_name: "Tester", last_name: "Man", email: "testerman@wo.com", password: "testerman85"}

  setup tag do
    {:ok, user} = if tag[:administrator], do:
      Account.create_user(@valid_params |> Map.put(:administrator, true)),
    else: Account.create_user(@valid_params)

    conn = build_conn() |> init_test_session(%{})
    {:ok, conn} = if tag[:login], do:
      conn |> Session.login(%{email: user.email, password: user.password}),
    else: {:ok, conn}

    {:ok, conn: conn}
  end

  @tag :administrator
  @tag :login
  test "administrator can login and view restricted areas", %{conn: conn} do
    conn = get conn, admin_sermon_series_path(conn, :index)
    assert html_response(conn, 200) =~ "Sermon Series"
  end

  @tag :login
  test "visitor can login but cannot view restricted areas", %{conn: conn} do
    conn = get conn, admin_sermon_series_path(conn, :index)
    assert redirected_to(conn) == home_path(conn, :index)
    assert get_flash(conn, :error) == "You must be logged in as an Administrator to access that page."
  end

  @tag :login
  test "logged in user cannot log in again", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert redirected_to(conn) == home_path(conn, :index)
    assert get_flash(conn, :info) == "You are already logged in."
  end
end
