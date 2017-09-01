defmodule Wo.TestHelpers do
  alias Wo.Resource

  def insert_sermon_series(attrs \\ %{}) do
    {:ok, series} = Resource.create_sermon_series(attrs)
    series
  end

  def insert_sermon(series, attrs \\ %{}) do
    {:ok, sermon} = Resource.create_sermon(attrs, series)
    sermon
  end
end
