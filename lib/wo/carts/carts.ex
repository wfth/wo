defmodule Wo.Carts do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Multi
  alias Wo.Repo

  alias Wo.Account.User
  alias Wo.Carts.Cart

  def list_carts(user_id) do
    Repo.all(from c in Cart, where: c.user_id == ^user_id)
  end

  def get_cart(id), do: Repo.get(Cart, id)

  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  def associate_cart(%Cart{} = cart, %User{} = user) do
    cart
    |> Repo.preload(:user)
    |> Cart.changeset(%{})
    |> put_assoc(:user, user)
    |> Repo.update()
  end

  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  def change_cart(%Cart{} = cart) do
    Cart.changeset(cart, %{})
  end

  alias Wo.Carts.CartItem

  def resource(%CartItem{} = cart_item) do
    type_mapping = %{"sermons" => Wo.Resource.Sermon, "sermon_series" => Wo.Resource.SermonSeries}
    Repo.get_by(type_mapping[cart_item.resource_type], id: cart_item.resource_id)
  end

  def list_cart_items(cart_id) do
    Repo.all(from c in CartItem, where: c.cart_id == ^cart_id)
  end

  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  def create_cart_item(%Cart{} = cart, attrs \\ %{}) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> put_assoc(:cart, cart)
    |> Repo.insert()
  end

  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => "0"} = _attrs) do
    delete_cart_item(cart_item)
  end
  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => quantity} = attrs) when is_integer(quantity) do
    _update_cart_item(cart_item, Map.put(attrs, "price", quantity * round(resource(cart_item).price)))
  end
  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => quantity} = attrs) when is_binary(quantity) do
    _update_cart_item(cart_item, Map.put(attrs, "price", String.to_integer(attrs["quantity"]) * round(resource(cart_item).price)))
  end
  defp _update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_cart_item(%CartItem{} = cart_item) do
    cart_item = cart_item |> Repo.preload(:cart)
    cart = cart_item.cart |> Repo.preload(:cart_items)

    Multi.new
    |> Multi.delete(:cart_item, cart_item)
    |> Multi.merge(fn(_changes) -> if Enum.count(cart.cart_items) == 1,
                                     do: Multi.new |> Multi.delete(:cart, cart),
                                     else: Multi.new
                                   end)
    |> Repo.transaction()
  end

  def change_cart_item(%CartItem{} = cart_item) do
    CartItem.changeset(cart_item, %{})
  end
end
