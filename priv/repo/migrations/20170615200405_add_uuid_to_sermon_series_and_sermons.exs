defmodule Wo.Repo.Migrations.AddUUIDToSermonSeriesAndSermons do
  use Ecto.Migration

  def change do
    alter table(:sermon_series) do
      add :uuid, :string
    end

    alter table(:sermons) do
      add :uuid, :string
    end
  end
end
