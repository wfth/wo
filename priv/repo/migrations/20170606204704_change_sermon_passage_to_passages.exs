defmodule Wo.Repo.Migrations.ChangeSermonPassageToPassages do
  use Ecto.Migration

  def change do
    alter table(:sermons) do
      remove :passage
      add :passages, :string
    end
  end
end
