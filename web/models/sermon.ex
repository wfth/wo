defmodule Wo.Sermon do
  use Wo.Web, :model

  schema "sermons" do
    field :title, :string
    field :description, :string
    field :passages, :string
    field :audio_key, :string
    field :transcript_key, :string
    field :buy_graphic_key, :string
    field :price, :float
    belongs_to :sermon_series, Wo.SermonSeries

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :passages, :audio_key, :transcript_key, :buy_graphic_key, :price])
    |> validate_required([:title, :description, :passages, :price])
  end
end
