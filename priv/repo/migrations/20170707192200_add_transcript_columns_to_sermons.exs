defmodule Wo.Repo.Migrations.AddTranscriptColumnsToSermons do
  use Ecto.Migration

  def change do
    alter table(:sermons) do
      add :transcript_url, :string
      add :transcript_text, :text
    end
  end
end
