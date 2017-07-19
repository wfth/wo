defmodule Wo.ContentBrowser.SermonSeries do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.ContentBrowser.SermonSeries


  schema "content_browser_sermon_series" do
    field :buy_graphic_url, :string
    field :description, :string
    field :graphic_url, :string
    field :passages, :string
    field :price, :integer
    field :released_on_string, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%SermonSeries{} = sermon_series, attrs) do
    sermon_series
    |> cast(attrs, [:title, :description, :passages, :released_on_string, :graphic_url, :buy_graphic_url, :price])
    |> validate_required([:title, :description, :passages, :released_on_string, :graphic_url, :buy_graphic_url, :price])
  end
end
