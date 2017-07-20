defmodule Wo.ContentBrowser.Sermon do
  use Ecto.Schema

  schema "sermons" do
    field :audio_url, :string
    field :buy_graphic_url, :string
    field :description, :string
    field :passages, :string
    field :price, :float
    field :title, :string
    field :transcript_text, :string
    field :transcript_url, :string

    timestamps()
  end
end
