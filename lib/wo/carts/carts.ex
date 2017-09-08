defmodule Wo.Carts do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Multi
  alias Wo.Repo

  alias Wo.Account.User
  alias Wo.Carts.Cart

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

  def merge_carts!(%Cart{} = cart, %Cart{} = kart) do
    new_cart = cart
    |> Wo.Repo.preload(:user)
    |> Map.delete(:id)
    |> Map.put(:cart_items, [])
    |> Wo.Repo.insert!()
    |> copy_cart_items!(from: cart)
    |> copy_cart_items!(from: kart)

    new_cart
  end

  defp copy_cart_items!(to_cart, from: from_cart) do
    from_cart = Repo.preload(from_cart, :cart_items)
    _copy_cart_items(to_cart, from_cart.cart_items)
  end
  defp _copy_cart_items(to_cart, []), do: to_cart |> Repo.preload(:cart_items, force: true)
  defp _copy_cart_items(to_cart, [head | tail]) do
    params = head |> Repo.preload(:cart) |> Map.from_struct() |> Map.put(:cart_id, to_cart.id) |> Map.delete(:id)
    Wo.Carts.CartItem.changeset(%Wo.Carts.CartItem{}, params) |> Wo.Repo.insert!()

    _copy_cart_items(to_cart, tail)
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

  def resource(type, id) do
    type_mapping = %{"sermons" => Wo.Resource.Sermon, "sermon_series" => Wo.Resource.SermonSeries}

    if type_mapping[type] && id, do:
      Repo.get_by(type_mapping[type], id: id),
    else: nil
  end
  def resource(%CartItem{} = cart_item) do
    resource(cart_item.resource_type, cart_item.resource_id)
  end

  def list_cart_items(cart_id, preload: true) do
    list_cart_items(cart_id) |> Repo.preload(:cart)
  end
  def list_cart_items(cart_id) do
    Repo.all(from c in CartItem, where: c.cart_id == ^cart_id)
  end

  def get_cart_item!(id, preload: true) do
    get_cart_item!(id) |> Repo.preload(:cart)
  end
  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  def create_cart_item(%{"resource_id" => resource_id,
                         "resource_type" => resource_type,
                         "quantity" => quantity} = attrs,
                       %Cart{} = cart) do
    _create_cart_item(attrs, resource_id, resource_type, cart, quantity)
  end
  def create_cart_item(%{"resource_id" => resource_id,
                         "resource_type" => resource_type} = attrs,
                       %Cart{} = cart) do
    _create_cart_item(attrs, resource_id, resource_type, cart)
  end
  def _create_cart_item(attrs, resource_id, resource_type, cart, quantity \\ 1) do
    existing_cart_item = Repo.get_by(CartItem, resource_id: resource_id, resource_type: resource_type, cart_id: cart.id)
    if existing_cart_item do
      update_cart_item(existing_cart_item, %{"quantity" => existing_cart_item.quantity + 1})
    else
      if resource = resource(resource_type, resource_id) do
        %CartItem{}
        |> CartItem.changeset(attrs |> Enum.into(%{"price" => resource.price * quantity, "quantity" => quantity}))
        |> put_assoc(:cart, cart)
        |> Repo.insert()
      else
        {:error, CartItem.changeset(%CartItem{}, attrs) |> add_error(:resource, "invalid")}
      end
    end
  end

  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => "0"} = _attrs) do
    delete_cart_item(cart_item)
  end
  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => quantity} = attrs) when is_integer(quantity) do
    _update_cart_item(cart_item, Map.put(attrs, "price", quantity * resource(cart_item).price))
  end
  def update_cart_item(%CartItem{} = cart_item, %{"quantity" => quantity} = attrs) when is_binary(quantity) do
    _update_cart_item(cart_item, Map.put(attrs, "price", String.to_integer(attrs["quantity"]) * resource(cart_item).price))
  end
  def update_cart_item(%CartItem{} = cart_item, attrs), do: {:error, CartItem.changeset(cart_item, attrs)}
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
