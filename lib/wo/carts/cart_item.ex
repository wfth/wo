defmodule Wo.Carts.CartItem do
  use Ecto.Schema

  import Ecto.Changeset

  alias Wo.Carts.Cart
  alias Wo.Carts.CartItem

  schema "cart_items" do
    field :price, :integer
    field :quantity, :integer
    field :resource_id, :integer
    field :resource_type, :string
    belongs_to :cart, Cart

    timestamps()
  end

  @doc false
  def changeset(%CartItem{} = cart_item, attrs) do
    cart_item
    |> cast(attrs, [:resource_type, :resource_id, :quantity, :price])
    |> validate_required([:resource_type, :resource_id, :quantity, :price])
  end
end
