defmodule Wo.Resource.SermonSeries do
  use Ecto.Schema

  import Ecto.Changeset

  alias Wo.Resource.SermonSeries
  alias Wo.Resource.Sermon

  schema "sermon_series" do
    field :buy_graphic_url, :string
    field :description, :string
    field :graphic_url, :string
    field :passages, :string
    field :price, :float
    field :released_on_string, :string
    field :title, :string
    field :uuid, :string
    has_many :sermons, Sermon, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%SermonSeries{} = sermon_series, attrs) do
    sermon_series
    |> cast(attrs, [:uuid, :title, :description, :passages, :released_on_string, :graphic_url, :buy_graphic_url, :price])
    |> validate_required([:uuid, :title, :description, :passages, :price])
  end
end
