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

  def sermon_series_fixture(attrs \\ %{}) do
    default_attrs = %{buy_graphic_url: "some buy_graphic_url",
                      description: "some description",
                      graphic_url: "some graphic_url",
                      passages: "some passages",
                      float_price: 42.5,
                      released_on_string: "some released_on_string",
                      title: "some title",
                      uuid: "some uuid"}
    {:ok, sermon_series} =
      attrs
      |> Enum.into(default_attrs)
      |> Wo.Resource.create_sermon_series()

    sermon_series
  end

  def sermon_fixture(attrs \\ %{}) do
    sermon_series = sermon_series_fixture()
    default_attrs = %{audio_url: "some audio_url",
                      buy_graphic_url: "some buy_graphic_url",
                      description: "some description",
                      passages: "some passages",
                      float_price: 42.5,
                      title: "some title",
                      transcript_text: "some transcript_text",
                      transcript_url: "some transcript_url",
                      uuid: "some uuid"}
    {:ok, sermon} =
      attrs
      |> Enum.into(default_attrs)
      |> Resource.create_sermon(sermon_series)

    sermon
  end
end
