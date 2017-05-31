defmodule Wo.TestHelpers do
  alias Wo.Repo

  def insert_sermon_series(attrs \\ %{}) do
    changes = Map.merge(%{
      title: "A Sermon Series",
      description: "A sermon series description.",
      price: "7.00"
    }, attrs)

    %Wo.SermonSeries{}
    |> Wo.SermonSeries.changeset(changes)
    |> Repo.insert!()
  end

  def insert_sermon(series, attrs \\ %{}) do
    series
    |> Ecto.build_assoc(:sermons, attrs)
    |> Repo.insert!()
  end
end
