defmodule Wo.Repo.Migrations.AddURLsToSermonsAndSermonSeries do
  use Ecto.Migration

  def change do
    # Not adding a transcript_url because we want to store and display
    # the transcript as plain text, not save it as a PDF.
    alter table(:sermons) do
      remove :audio_key
      remove :transcript_key
      remove :buy_graphic_key
      add :audio_url, :string
      add :buy_graphic_url, :string
    end

    alter table(:sermon_series) do
      remove :graphic_key
      remove :buy_graphic_key
      add :graphic_url, :string
      add :buy_graphic_url, :string
    end
  end
end
