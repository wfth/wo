defmodule Wo.Web.SermonSeries do
  use Wo.Web, :model

  schema "sermon_series" do
    field :uuid, :string
    field :title, :string
    field :description, :string
    field :passages, :string
    field :released_on_string, :string
    field :graphic_url, :string
    field :buy_graphic_url, :string
    field :price, :float
    has_many :sermons, Wo.Web.Sermon, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :title, :description, :passages, :released_on_string, :graphic_url, :buy_graphic_url, :price])
    |> validate_required([:uuid, :title, :description, :passages, :price])
  end

  defimpl Phoenix.Param, for: Wo.Web.SermonSeries do
    def to_param(series) do
      "#{series.id}-" <> (series.title
      |> String.downcase
      |> String.strip
      |> String.replace(~r/[ :]/, "-")
      |> String.replace(~r/[^A-Za-z0-9-]/, "")
      |> String.replace(~r/-+/, "-")
      |> String.trim_trailing("-"))
    end
  end
end
