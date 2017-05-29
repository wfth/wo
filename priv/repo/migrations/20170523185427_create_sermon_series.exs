defmodule Wo.Repo.Migrations.CreateSermonSeries do
  use Ecto.Migration

  def change do
    create table(:sermon_series) do
      add :title, :string
      add :description, :text
      add :released_on_string, :string
      add :graphic_key, :string
      add :buy_graphic_key, :string
      add :price, :float

      timestamps()
    end

  end
end
