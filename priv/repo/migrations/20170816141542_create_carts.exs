defmodule Wo.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :tax, :integer
      add :total, :integer
      add :purchased_at, :utc_datetime
      add :stripe_charge_id, :string
      add :address, :text
      add :city, :string
      add :state, :string
      add :zip, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
