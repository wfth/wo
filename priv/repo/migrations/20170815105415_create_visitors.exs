defmodule Wo.Repo.Migrations.CreateVisitors do
  use Ecto.Migration

  def change do
    create table(:visitors) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :crypted_password, :string

      timestamps()
    end

    create unique_index(:visitors, [:email])
  end
end
