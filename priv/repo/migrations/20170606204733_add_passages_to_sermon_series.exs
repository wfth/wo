defmodule Wo.Repo.Migrations.AddPassagesToSermonSeries do
  use Ecto.Migration

  def change do
    alter table(:sermon_series) do
      add :passages, :text
    end
  end
end
