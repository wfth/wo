defmodule Wo.ContentBrowser.SearchDocument do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.ContentBrowser.SearchDocument


  schema "content_browser_search_documents" do
    field :content, :string
    field :document_id, :integer
    field :document_table, :string

    timestamps()
  end

  @doc false
  def changeset(%SearchDocument{} = search_document, attrs) do
    search_document
    |> cast(attrs, [:document_table, :document_id, :content])
    |> validate_required([:document_table, :document_id, :content])
  end
end
