defmodule Wo.SermonSeries do
  use Wo.Web, :model

  schema "sermon_series" do
    field :title, :string
    field :description, :string
    field :passages, :string
    field :released_on_string, :string
    field :graphic_key, :string
    field :buy_graphic_key, :string
    field :price, :float
    has_many :sermons, Wo.Sermon, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :passages, :released_on_string, :graphic_key, :buy_graphic_key, :price])
    |> validate_required([:title, :description, :price])
  end
end
