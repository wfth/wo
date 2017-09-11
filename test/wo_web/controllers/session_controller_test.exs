defmodule WoWeb.SessionControllerTest do
  use WoWeb.ConnCase

  alias Wo.Account
  alias Wo.Carts
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

    {:ok, conn: conn, user: user}
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

  test "logging in associates the anonymous cart with the user", %{conn: conn, user: user} do
    sermon = sermon_fixture()
    {:ok, cart} = Carts.create_cart()
    Carts.create_cart_item(%{"resource_id" => sermon.id,
                             "resource_type" => "sermons",
                             "quantity" => 2}, cart)
    assert Wo.Repo.preload(user, :carts).carts == []

    conn = Session.put_cart(cart, conn)
    {:ok, _} = Session.login(conn, %{email: user.email, password: user.password})

    user_carts = Wo.Repo.preload(user, :carts).carts |> Wo.Repo.preload(:user)
    cart = Wo.Carts.get_cart(cart.id)
    assert List.first(user_carts) == Wo.Repo.preload(cart, :user)
  end

  @tag :login
  test "logging out removes the associated cart from the session", %{conn: conn, user: user} do
    sermon = sermon_fixture()
    {:ok, cart} = Carts.create_cart()
    {:ok, cart} = Carts.associate_cart(cart, user)
    Carts.create_cart_item(%{"resource_id" => sermon.id,
                             "resource_type" => "sermons",
                             "quantity" => 2}, cart)

    conn = Session.put_cart(cart, conn)
           |> get(cart_path(conn, :show))
    refute Session.cart(conn) == nil
    assert html_response(conn, 200) =~ sermon.title

    conn = delete(conn, session_path(conn, :delete))
           |> get(cart_path(conn, :show))

    assert Session.cart(conn) == nil
    refute html_response(conn, 200) =~ sermon.title
  end

  @tag :login
  test "logging in to an account with an associated cart while there is a cart in the session merges the carts", %{conn: conn, user: user} do
    sermon = sermon_fixture()
    {:ok, cart} = Carts.create_cart()
    {:ok, cart} = Carts.associate_cart(cart, user)
    Carts.create_cart_item(%{"resource_id" => sermon.id,
                             "resource_type" => "sermons",
                             "quantity" => 2}, cart)

    conn = Session.put_cart(cart, conn)
           |> delete(session_path(conn, :delete))
           |> get(cart_path(conn, :show))
    assert Session.cart(conn) == nil
    refute html_response(conn, 200) =~ sermon.title

    sermon_series = sermon_series_fixture()
    {:ok, kart} = Carts.create_cart()
    {:ok, kart} = Carts.associate_cart(kart, user)
    Carts.create_cart_item(%{"resource_id" => sermon_series.id,
                             "resource_type" => "sermon_series",
                             "quantity" => 2}, kart)

    conn = recycle(conn) |> init_test_session(%{})
    conn = Session.put_cart(kart, conn)
    assert (Session.cart(conn) |> Wo.Repo.preload(:cart_items)).cart_items
           |> Enum.count() == 1

    {:ok, conn} = Session.login(conn, %{email: user.email, password: user.password})
    conn = get(conn, cart_path(conn, :show))
    assert (Session.cart(conn) |> Wo.Repo.preload(:cart_items)).cart_items
           |> Enum.count() == 2
    assert html_response(conn, 200) =~ sermon_series.title
    assert html_response(conn, 200) =~ sermon.title
  end
end
