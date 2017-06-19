defmodule Wo.Sermon do
  use Wo.Web, :model

  schema "sermons" do
    field :uuid, :string
    field :title, :string
    field :description, :string
    field :passages, :string
    field :audio_url, :string
    field :buy_graphic_url, :string
    field :price, :float
    belongs_to :sermon_series, Wo.SermonSeries

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :passages, :audio_url, :buy_graphic_url, :price, :uuid])
    |> validate_required([:title, :description, :passages, :price, :uuid])
  end
end
