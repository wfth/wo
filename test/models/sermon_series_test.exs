defmodule Wo.SermonSeriesTest do
  use Wo.ModelCase

  alias Wo.SermonSeries

  @valid_attrs %{buy_graphic_key: "some content", description: "some content", graphic_key: "some content", price: "120.5", released_on: %{day: 17, month: 4, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SermonSeries.changeset(%SermonSeries{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SermonSeries.changeset(%SermonSeries{}, @invalid_attrs)
    refute changeset.valid?
  end
end