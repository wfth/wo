defmodule Wo.Repo.Migrations.ConfigureRowsToBeNotNull do
  use Ecto.Migration

  def change do
    alter table(:sermon_series) do
      modify :title, :string, null: false
      modify :description, :text, default: ""
      modify :passages, :text, default: ""
      modify :uuid, :string, null: false
    end

    alter table(:sermons) do
      modify :title, :string, null: false
      modify :description, :text, default: ""
      modify :passages, :text, default: ""
      modify :uuid, :string, null: false
    end
  end
end
