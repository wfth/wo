defmodule Wo.Account.Administrator do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.Account.Administrator

  schema "administrators" do
    field :password, :string, virtual: true
    field :crypted_password, :string
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Administrator{} = administrator, attrs) do
    administrator
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 5)
  end
end
