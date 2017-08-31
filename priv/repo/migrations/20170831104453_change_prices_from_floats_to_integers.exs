defmodule Wo.Repo.Migrations.ChangePricesFromFloatsToIntegers do
  use Ecto.Migration

  def change do
    alter table(:sermons) do
      modify :price, :integer
    end

    alter table(:sermon_series) do
      modify :price, :integer
    end
  end
end
