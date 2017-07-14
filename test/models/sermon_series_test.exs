defmodule Wo.Web.SermonSeriesTest do
  use Wo.ModelCase

  alias Wo.Web.SermonSeries

  @valid_attrs %{buy_graphic_url: "some content", description: "some content", graphic_url: "some content", passages: "some content", price: "120.5", released_on_string: "4-17-2010", title: "some content", uuid: "some content"}
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
