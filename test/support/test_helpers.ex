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

  # We're not the only hacks around here. Not naming names... (cough cough Chris McCord cough cough) - https://github.com/phoenixframework/phoenix/commit/82a3db6de7293d0910d7b34e2bbfcaf6e4673cf0#diff-5b917b144ec1fa2a5d8300fdb2a51fb5R78
  def postgresql_static_datetime() do
    %NaiveDateTime{year: 2010, month: 4, day: 17, hour: 14, minute: 0, second: 0, microsecond: {0, 6}}
  end
end
