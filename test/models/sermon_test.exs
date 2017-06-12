defmodule Wo.SermonTest do
  use Wo.ModelCase

  alias Wo.Sermon

  @valid_attrs %{audio_url: "some content", buy_graphic_url: "some content", description: "some content", passages: "some content", price: "120.5", sermon_series_id: 42, title: "some content", transcript_key: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Sermon.changeset(%Sermon{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sermon.changeset(%Sermon{}, @invalid_attrs)
    refute changeset.valid?
  end
end
