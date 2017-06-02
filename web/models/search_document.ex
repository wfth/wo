defmodule Wo.SearchDocument do
  use Wo.Web, :model

  schema "search_documents" do
    field :document_table, :string
    field :document_id, :integer
    field :language, :string
    field :content, :string
  end
end
