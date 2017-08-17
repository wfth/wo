defmodule Wo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :crypted_password, :string
      add :administrator, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
