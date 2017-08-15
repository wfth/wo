defmodule Wo.Account.Visitor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.Account.Visitor

  schema "visitors" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    has_many :carts, Wo.Carts.Cart, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(%Visitor{} = visitor, attrs) do
    visitor
    |> cast(attrs, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 5)
  end
end
