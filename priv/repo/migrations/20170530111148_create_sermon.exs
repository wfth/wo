defmodule Wo.Repo.Migrations.CreateSermon do
  use Ecto.Migration

  def change do
    create table(:sermons) do
      add :title, :string
      add :description, :text
      add :passage, :string
      add :sermon_series_id, references(:sermon_series)
      add :audio_key, :string
      add :transcript_key, :string
      add :buy_graphic_key, :string
      add :price, :float

      timestamps()
    end

  end
end
