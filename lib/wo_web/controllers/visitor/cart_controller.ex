defmodule WoWeb.Visitor.CartController do
  use WoWeb, :controller

  alias Wo.Carts

  def show(conn, _params) do
    if cart = WoWeb.Session.cart(conn) do
      cart_items = Carts.list_cart_items(cart.id)
      render conn, "show.html", cart_items: cart_items
    else
      render conn, "show.html", cart_items: []
    end
  end

  def delete(conn, _params) do
    if cart = WoWeb.Session.cart(conn) do
      Carts.delete_cart(cart)
    end

    render conn, "show.html", cart_items: []
  end
end
