defmodule Wo.Sermon do
  use Wo.Web, :model

  schema "sermons" do
    field :uuid, :string
    field :title, :string
    field :description, :string
    field :passages, :string
    field :audio_url, :string
    field :buy_graphic_url, :string
    field :transcript_url, :string
    field :transcript_text, :string
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

  defimpl Phoenix.Param, for: Wo.Sermon do
    def to_param(sermon) do
      "#{sermon.id}-" <> (sermon.title
      |> String.downcase
      |> String.strip
      |> String.replace(~r/[ :]/, "-")
      |> String.replace(~r/[^A-Za-z0-9-]/, "")
      |> String.replace(~r/-+/, "-"))
      |> String.trim_trailing("-")
    end
  end
end
