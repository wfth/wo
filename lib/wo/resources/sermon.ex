defmodule Wo.Resource.Sermon do
  use Ecto.Schema

  import Ecto.Changeset
  import Wo.Resource.PurchasableResource

  alias Wo.Resource.Sermon
  alias Wo.Resource.SermonSeries

  schema "sermons" do
    field :audio_url, :string
    field :buy_graphic_url, :string
    field :description, :string
    field :passages, :string
    field :price, :integer
    field :float_price, :float, virtual: true
    field :title, :string
    field :transcript_text, :string
    field :transcript_url, :string
    field :uuid, :string
    belongs_to :sermon_series, SermonSeries

    timestamps()
  end

  @doc false
  def changeset(%Sermon{} = sermon, attrs) do
    sermon
    |> cast(attrs, [:uuid, :title, :description, :passages, :audio_url, :buy_graphic_url, :transcript_url, :transcript_text, :float_price])
    |> put_price()
    |> validate_required([:uuid, :title, :description, :passages, :float_price])
  end
end
