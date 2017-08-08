defmodule Wo.TestHelpers do
  alias Wo.Repo

  def insert_sermon_series(attrs \\ %{}) do
    %WoWeb.SermonSeries{}
    |> WoWeb.SermonSeries.changeset(attrs)
    |> Repo.insert!()
  end

  def insert_sermon(series, attrs \\ %{}) do
    series
    |> Ecto.build_assoc(:sermons, attrs)
    |> Repo.insert!()
  end
end
