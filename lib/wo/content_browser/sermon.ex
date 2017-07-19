defmodule Wo.ContentBrowser.Sermon do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wo.ContentBrowser.Sermon


  schema "content_browser_sermons" do
    field :audio_url, :string
    field :buy_graphic_url, :string
    field :description, :string
    field :passages, :string
    field :price, :integer
    field :title, :string
    field :transcript_text, :string
    field :transcript_url, :string

    timestamps()
  end

  @doc false
  def changeset(%Sermon{} = sermon, attrs) do
    sermon
    |> cast(attrs, [:title, :description, :passages, :audio_url, :buy_graphic_url, :transcript_url, :transcript_text, :price])
    |> validate_required([:title, :description, :passages, :audio_url, :buy_graphic_url, :transcript_url, :transcript_text, :price])
  end
end
