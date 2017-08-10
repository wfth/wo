defmodule Wo.Repo.Migrations.CreateAdministrators do
  use Ecto.Migration

  def change do
    create table(:administrators) do
      add :name, :string
      add :email, :string
      add :crypted_password, :string

      timestamps()
    end

    create unique_index(:administrators, [:email])
  end
end
