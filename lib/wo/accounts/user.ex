defmodule Wo.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.Account.User

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    field :administrator, :boolean
    has_many :carts, Wo.Carts.Cart, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :administrator])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 5)
  end
end
