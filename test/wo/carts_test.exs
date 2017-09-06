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
  end

  describe "cart_items" do
    alias Wo.Carts.Cart
    alias Wo.Carts.CartItem

    # TO TEST
    # - [] creating first cart item creates a cart
    # - [] delete sole cart item deletes associated cart
    # - [] creating a cart item for a resource that already has a cart item
    #      adds to the quantity of the existing cart item

    def sermon_series_fixture(attrs \\ %{}) do
      sermon_series_attrs = %{uuid: "some uuid",
                   title: "some title",
                   description: "some description",
                   passages: "some passages",
                   float_price: 20.0}
      {:ok, sermon_series} =
        attrs
        |> Enum.into(sermon_series_attrs)
        |> Wo.Resource.create_sermon_series()

      sermon_series
    end

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
      assert cart_item.price == 6000
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
      assert cart_item.price == 10000
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

