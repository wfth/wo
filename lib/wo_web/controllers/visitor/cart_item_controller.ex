defmodule WoWeb.Visitor.CartItemController do
  use WoWeb, :controller

  alias Wo.Carts
  require IEx

  def create(conn, cart_item_params) do
    {:ok, cart} = unless WoWeb.Session.cart(conn), do: Carts.create_cart(), else: {:ok, WoWeb.Session.cart(conn)}
    conn = WoWeb.Session.put_cart(conn, cart)

    case Carts.create_cart_item(cart, cart_item_params |> Map.put("quantity", 1)) do
      {:ok, _cart_item} ->
        conn
        |> put_flash(:info, "Added item to your cart.")
        |> redirect(to: sermon_series_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not add that item to your cart.")
        |> redirect(to: sermon_series_path(conn, :index))
    end
  end

  def delete(conn, %{"cart_item_id" => cart_item_id}) do
    cart_item = Carts.get_cart_item!(cart_item_id)
    Carts.delete_cart_item(cart_item)

    redirect(conn, to: cart_path(conn, :show))
  end
end
