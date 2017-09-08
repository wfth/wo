defmodule Wo.CartsTest do
  use Wo.DataCase

  alias Wo.Carts

  describe "carts" do
    alias Wo.Carts.Cart

    @valid_attrs %{address: "123 Fake Rd", city: "City", purchased_at: postgresql_static_datetime(), state: "NC", stripe_charge_id: "somethingsomething", tax: 200, total: 1605, zip: "12345"}
    @update_attrs %{address: "123 Faker Rd", city: "City2", purchased_at: postgresql_static_datetime(), state: "NY", stripe_charge_id: "somethingsomething2", tax: 300, total: 1805, zip: "12340"}

    def cart_fixture(attrs \\ %{}) do
      {:ok, cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carts.create_cart()

      cart
    end

    test "get_cart/1 returns the cart with given id" do
      cart = cart_fixture()
      assert Carts.get_cart(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = Carts.create_cart(@valid_attrs)
      assert cart.address == "123 Fake Rd"
      assert cart.city == "City"
      assert cart.purchased_at == postgresql_static_datetime()
      assert cart.state == "NC"
      assert cart.stripe_charge_id == "somethingsomething"
      assert cart.tax == 200
      assert cart.total == 1605
      assert cart.zip == "12345"
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      assert {:ok, cart} = Carts.update_cart(cart, @update_attrs)
      assert %Cart{} = cart
      assert cart.address == "123 Faker Rd"
      assert cart.city == "City2"
      assert cart.purchased_at == postgresql_static_datetime()
      assert cart.state == "NY"
      assert cart.stripe_charge_id == "somethingsomething2"
      assert cart.tax == 300
      assert cart.total == 1805
      assert cart.zip == "12340"
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert Carts.get_cart(cart.id) == nil
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end

    test "merge_carts/2 returns a new merged cart" do
      {cart, kart, sermon_series, sermon} = merge_carts_data()

      {:ok, cart_item} = Carts.create_cart_item(%{"resource_id" => sermon_series.id,
                                                  "resource_type" => "sermon_series",
                                                  "quantity" => 1}, cart)
      {:ok, kart_item} = Carts.create_cart_item(%{"resource_id" => sermon.id,
                                                  "resource_type" => "sermons",
                                                  "quantity" => 4}, kart)

      merged_cart = Carts.merge_carts!(cart, kart)

      # Make sure the carts and their cart items are unchanged
      assert cart == Carts.get_cart(cart.id)
      assert [Carts.get_cart_item!(cart_item.id)] == (cart |> Repo.preload(:cart_items, force: true)).cart_items
      assert kart == Carts.get_cart(kart.id)
      assert [Carts.get_cart_item!(kart_item.id)] == (kart |> Repo.preload(:cart_items, force: true)).cart_items

      # Check contents of new merged cart
      assert merged_cart.id != cart.id && merged_cart.id != kart.id
      for ci <- merged_cart.cart_items do
        assert cart_items_equal(ci, cart_item) || cart_items_equal(ci, kart_item)
        assert ci.cart_id == merged_cart.id
      end
    end

    test "merge_carts/2 combines cart items when possible" do
      {cart, kart, sermon_series, _sermon} = merge_carts_data()

      {:ok, _cart_item} = Carts.create_cart_item(%{"resource_id" => sermon_series.id,
                                                  "resource_type" => "sermon_series",
                                                  "quantity" => 1}, cart)
      {:ok, _kart_item} = Carts.create_cart_item(%{"resource_id" => sermon_series.id,
                                                  "resource_type" => "sermon_series",
                                                  "quantity" => 4}, kart)

      merged_cart = Carts.merge_carts!(cart, kart)

      assert Enum.count(merged_cart.cart_items) == 1
      assert List.first(merged_cart.cart_items).quantity == 5
    end

    def merge_carts_data() do
      cart = cart_fixture()
      kart = cart_fixture()
      sermon_series = sermon_series_fixture()
      sermon = sermon_fixture()

      {cart, kart, sermon_series, sermon}
    end

    def cart_items_equal(cart_item, kart_item) do
      cart_item.price == kart_item.price &&
        cart_item.quantity == kart_item.quantity &&
        cart_item.resource_id == kart_item.resource_id &&
        cart_item.resource_type == kart_item.resource_type
    end
  end

  describe "cart_items" do
    alias Wo.Carts.Cart
    alias Wo.Carts.CartItem

    # TO TEST
    # - [] creating first cart item creates a cart
    # - [] delete sole cart item deletes associated cart
    # - [] creating a cart item for a resource that already has a cart item
    #      adds to the quantity of the existing cart item

    setup tags do
      sermon_series = sermon_series_fixture()
      cart = cart_fixture()
      {_, resource_type} = sermon_series.__meta__.source

      resource_attrs = %{"resource_id" => sermon_series.id, "resource_type" => resource_type}
      {:ok, cart_item} = Enum.into(resource_attrs, %{"quantity" => tags[:quantity] || 1})
                         |> Carts.create_cart_item(cart)

      %{sermon_series: sermon_series, cart: cart, cart_item: cart_item, resource_attrs: resource_attrs}
    end

    test "list_cart_items/0 returns all cart_item", %{cart_item: cart_item} do
      assert Carts.list_cart_items(cart_item.cart.id, preload: true) == [cart_item]
    end

    test "get_cart_item!/1 returns the cart_item with given id", %{cart_item: cart_item} do
      assert Carts.get_cart_item!(cart_item.id, preload: true) == cart_item
    end

    @tag quantity: 3
    test "create_cart_item/1 with valid data creates a cart_item", %{cart_item: cart_item, resource_attrs: resource_attrs} do
      assert cart_item.price == 12750
      assert cart_item.quantity == 3
      assert cart_item.resource_id == resource_attrs["resource_id"]
      assert cart_item.resource_type == resource_attrs["resource_type"]
    end

    test "create_cart_item/1 with invalid data returns error changeset", %{cart: cart} do
      assert {:error, %Ecto.Changeset{}} = Carts.create_cart_item(%{"quantity" => 3, "resource_id" => 900000, "resource_type" => "chuckles"}, cart)
    end

    test "update_cart_item/2 with valid data updates the cart_item", %{cart_item: cart_item, resource_attrs: resource_attrs} do
      assert {:ok, cart_item} = Carts.update_cart_item(cart_item, %{"quantity" => 5})
      assert %CartItem{} = cart_item
      assert cart_item.price == 21250
      assert cart_item.quantity == 5
      assert cart_item.resource_id == resource_attrs["resource_id"]
      assert cart_item.resource_type == resource_attrs["resource_type"]
    end

    test "update_cart_item/2 with invalid data returns error changeset", %{cart_item: cart_item} do
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart_item(cart_item, %{"quantity" => -1})
      assert cart_item == Carts.get_cart_item!(cart_item.id, preload: true)
    end

    test "delete_cart_item/1 deletes the cart_item", %{cart_item: cart_item} do
      assert {:ok, %{cart: %Cart{}, cart_item: %CartItem{}}} = Carts.delete_cart_item(cart_item)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart_item!(cart_item.id) end
    end

    test "change_cart_item/1 returns a cart_item changeset", %{cart_item: cart_item} do
      assert %Ecto.Changeset{} = Carts.change_cart_item(cart_item)
    end
  end
end

