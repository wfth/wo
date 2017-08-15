defmodule Wo.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items) do
      add :cart_id, references(:carts)
      add :resource_type, :string
      add :resource_id, :integer
      add :quantity, :integer
      add :price, :integer

      timestamps()
    end

  end
end
