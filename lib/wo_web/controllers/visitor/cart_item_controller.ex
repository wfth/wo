defmodule WoWeb.Visitor.CartItemController do
  use WoWeb, :controller

  alias Wo.Carts

  def create(conn, cart_item_params) do
    {:ok, cart} = unless WoWeb.Session.cart(conn), do: Carts.create_cart(), else: {:ok, WoWeb.Session.cart(conn)}
    cart = cart |> Wo.Repo.preload(:cart_items)
    conn = WoWeb.Session.put_cart(conn, cart)

    if cart_item = Enum.find(cart.cart_items, fn(ci) -> ci.resource_id == cart_item_params["resource_id"] |> String.to_integer end) do
      redirect_with_db_operation(conn, &Carts.update_cart_item/2, cart_item, %{"quantity" => cart_item.quantity + 1})
    else
      redirect_with_db_operation(conn, &Carts.create_cart_item/2, cart, cart_item_params |> Map.put("quantity", 1))
    end
  end

  def delete(conn, %{"cart_item_id" => cart_item_id}) do
    cart_item = Carts.get_cart_item!(cart_item_id) |> Wo.Repo.preload(:cart)
    Carts.delete_cart_item(cart_item)

    cart = cart_item.cart |> Wo.Repo.preload(:cart_items)
    if Enum.empty?(cart.cart_items) do
      Carts.delete_cart(cart)
    end

    redirect(conn, to: cart_path(conn, :show))
  end

  defp redirect_with_db_operation(conn, operation, model, params) do
    case operation.(model, params) do
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
end
