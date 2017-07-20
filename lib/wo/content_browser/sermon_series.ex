defmodule Wo.ContentBrowser.SermonSeries do
  use Ecto.Schema

  schema "sermon_series" do
    field :buy_graphic_url, :string
    field :description, :string
    field :graphic_url, :string
    field :passages, :string
    field :price, :float
    field :released_on_string, :string
    field :title, :string

    timestamps()
  end
end
