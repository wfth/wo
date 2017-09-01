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
end

