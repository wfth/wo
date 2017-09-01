defmodule Wo.Carts.Cart do
  use Ecto.Schema

  import Ecto.Changeset

  alias Wo.Carts.Cart
  alias Wo.Carts.CartItem

  schema "carts" do
    field :address, :string
    field :city, :string
    field :purchased_at, :naive_datetime
    field :state, :string
    field :stripe_charge_id, :string
    field :tax, :integer
    field :total, :integer
    field :zip, :string
    belongs_to :user, Wo.Account.User
    has_many :cart_items, CartItem, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Cart{} = cart, attrs) do
    cart
    |> cast(attrs, [:tax, :total, :purchased_at, :stripe_charge_id, :address, :city, :state, :zip])
  end
end
