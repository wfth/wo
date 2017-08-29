defmodule WoWeb.Visitor.CartItemController do
  use WoWeb, :controller

  alias Wo.Carts

  action_fallback WoWeb.FallbackController

  def create(conn, cart_item_params) do
    {:ok, cart} = unless WoWeb.Session.cart(conn), do: Carts.create_cart(), else: {:ok, WoWeb.Session.cart(conn)}
    cart = cart |> Wo.Repo.preload(:cart_items)
    conn = WoWeb.Session.put_cart(conn, cart)

    with {:ok, _cart_item} <- Carts.create_cart_item(cart, cart_item_params) do
      conn
      |> put_flash(:info, "Added item to your cart.")
      |> redirect(to: cart_item_params["redirect_to"])
    end
  end

  def update(conn, %{"id" => cart_item_id, "cart_item" => cart_item_params}) do
    cart_item = Carts.get_cart_item!(cart_item_id)

    with {:ok, _cart_item} <- Carts.update_cart_item(cart_item, cart_item_params) do
      redirect(conn, to: cart_path(conn, :show))
    end
  end

  def delete(conn, %{"cart_item_id" => cart_item_id}) do
    cart_item = Carts.get_cart_item!(cart_item_id)
    Carts.delete_cart_item(cart_item)

    redirect(conn, to: cart_path(conn, :show))
  end
end
