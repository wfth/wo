defmodule Wo.Resource.SearchDocument do
  use Ecto.Schema

  schema "search_documents" do
    field :content, :string
    field :document_id, :integer
    field :document_table, :string

    timestamps()
  end
end
