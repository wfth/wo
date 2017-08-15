defmodule Wo.CartsTest do
  use Wo.DataCase

  alias Wo.Carts

  describe "visitors" do
    alias Wo.Carts.Visitor

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

    def visitor_fixture(attrs \\ %{}) do
      {:ok, visitor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carts.create_visitor()

      visitor
    end

    test "list_visitors/0 returns all visitors" do
      visitor = visitor_fixture()
      assert Carts.list_visitors() == [visitor]
    end

    test "get_visitor!/1 returns the visitor with given id" do
      visitor = visitor_fixture()
      assert Carts.get_visitor!(visitor.id) == visitor
    end

    test "create_visitor/1 with valid data creates a visitor" do
      assert {:ok, %Visitor{} = visitor} = Carts.create_visitor(@valid_attrs)
      assert visitor.email == "some email"
      assert visitor.first_name == "some first_name"
      assert visitor.last_name == "some last_name"
    end

    test "create_visitor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_visitor(@invalid_attrs)
    end

    test "update_visitor/2 with valid data updates the visitor" do
      visitor = visitor_fixture()
      assert {:ok, visitor} = Carts.update_visitor(visitor, @update_attrs)
      assert %Visitor{} = visitor
      assert visitor.email == "some updated email"
      assert visitor.first_name == "some updated first_name"
      assert visitor.last_name == "some updated last_name"
    end

    test "update_visitor/2 with invalid data returns error changeset" do
      visitor = visitor_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_visitor(visitor, @invalid_attrs)
      assert visitor == Carts.get_visitor!(visitor.id)
    end

    test "delete_visitor/1 deletes the visitor" do
      visitor = visitor_fixture()
      assert {:ok, %Visitor{}} = Carts.delete_visitor(visitor)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_visitor!(visitor.id) end
    end

    test "change_visitor/1 returns a visitor changeset" do
      visitor = visitor_fixture()
      assert %Ecto.Changeset{} = Carts.change_visitor(visitor)
    end
  end

  describe "carts" do
    alias Wo.Carts.Cart

    @valid_attrs %{address: "some address", city: "some city", purchased_at: "2010-04-17 14:00:00.000000Z", state: "some state", stripe_charge_id: "some stripe_charge_id", tax: 42, total: 42, zip: "some zip"}
    @update_attrs %{address: "some updated address", city: "some updated city", purchased_at: "2011-05-18 15:01:01.000000Z", state: "some updated state", stripe_charge_id: "some updated stripe_charge_id", tax: 43, total: 43, zip: "some updated zip"}
    @invalid_attrs %{address: nil, city: nil, purchased_at: nil, state: nil, stripe_charge_id: nil, tax: nil, total: nil, zip: nil}

    def cart_fixture(attrs \\ %{}) do
      {:ok, cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carts.create_cart()

      cart
    end

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert Carts.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert Carts.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = Carts.create_cart(@valid_attrs)
      assert cart.address == "some address"
      assert cart.city == "some city"
      assert cart.purchased_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert cart.state == "some state"
      assert cart.stripe_charge_id == "some stripe_charge_id"
      assert cart.tax == 42
      assert cart.total == 42
      assert cart.zip == "some zip"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      assert {:ok, cart} = Carts.update_cart(cart, @update_attrs)
      assert %Cart{} = cart
      assert cart.address == "some updated address"
      assert cart.city == "some updated city"
      assert cart.purchased_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert cart.state == "some updated state"
      assert cart.stripe_charge_id == "some updated stripe_charge_id"
      assert cart.tax == 43
      assert cart.total == 43
      assert cart.zip == "some updated zip"
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart(cart, @invalid_attrs)
      assert cart == Carts.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end
  end

  describe "cart_items" do
    alias Wo.Carts.CartItem

    @valid_attrs %{price: 42, quantity: 42, resource_id: 42, resource_type: "some resource_type"}
    @update_attrs %{price: 43, quantity: 43, resource_id: 43, resource_type: "some updated resource_type"}
    @invalid_attrs %{price: nil, quantity: nil, resource_id: nil, resource_type: nil}

    def cart_item_fixture(attrs \\ %{}) do
      {:ok, cart_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carts.create_cart_item()

      cart_item
    end

    test "list_cart_items/0 returns all cart_items" do
      cart_item = cart_item_fixture()
      assert Carts.list_cart_items() == [cart_item]
    end

    test "get_cart_item!/1 returns the cart_item with given id" do
      cart_item = cart_item_fixture()
      assert Carts.get_cart_item!(cart_item.id) == cart_item
    end

    test "create_cart_item/1 with valid data creates a cart_item" do
      assert {:ok, %CartItem{} = cart_item} = Carts.create_cart_item(@valid_attrs)
      assert cart_item.price == 42
      assert cart_item.quantity == 42
      assert cart_item.resource_id == 42
      assert cart_item.resource_type == "some resource_type"
    end

    test "create_cart_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_cart_item(@invalid_attrs)
    end

    test "update_cart_item/2 with valid data updates the cart_item" do
      cart_item = cart_item_fixture()
      assert {:ok, cart_item} = Carts.update_cart_item(cart_item, @update_attrs)
      assert %CartItem{} = cart_item
      assert cart_item.price == 43
      assert cart_item.quantity == 43
      assert cart_item.resource_id == 43
      assert cart_item.resource_type == "some updated resource_type"
    end

    test "update_cart_item/2 with invalid data returns error changeset" do
      cart_item = cart_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart_item(cart_item, @invalid_attrs)
      assert cart_item == Carts.get_cart_item!(cart_item.id)
    end

    test "delete_cart_item/1 deletes the cart_item" do
      cart_item = cart_item_fixture()
      assert {:ok, %CartItem{}} = Carts.delete_cart_item(cart_item)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart_item!(cart_item.id) end
    end

    test "change_cart_item/1 returns a cart_item changeset" do
      cart_item = cart_item_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart_item(cart_item)
    end
  end
end
