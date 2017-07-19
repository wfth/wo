defmodule Wo.ContentEditorTest do
  use Wo.DataCase

  alias Wo.ContentEditor

  describe "sermon_series" do
    alias Wo.ContentEditor.SermonSeries

    @valid_attrs %{buy_graphic_url: "some buy_graphic_url", description: "some description", graphic_url: "some graphic_url", passages: "some passages", price: 42, released_on_string: "some released_on_string", title: "some title", uuid: "some uuid"}
    @update_attrs %{buy_graphic_url: "some updated buy_graphic_url", description: "some updated description", graphic_url: "some updated graphic_url", passages: "some updated passages", price: 43, released_on_string: "some updated released_on_string", title: "some updated title", uuid: "some updated uuid"}
    @invalid_attrs %{buy_graphic_url: nil, description: nil, graphic_url: nil, passages: nil, price: nil, released_on_string: nil, title: nil, uuid: nil}

    def sermon_series_fixture(attrs \\ %{}) do
      {:ok, sermon_series} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentEditor.create_sermon_series()

      sermon_series
    end

    test "list_sermon_series/0 returns all sermon_series" do
      sermon_series = sermon_series_fixture()
      assert ContentEditor.list_sermon_series() == [sermon_series]
    end

    test "get_sermon_series!/1 returns the sermon_series with given id" do
      sermon_series = sermon_series_fixture()
      assert ContentEditor.get_sermon_series!(sermon_series.id) == sermon_series
    end

    test "create_sermon_series/1 with valid data creates a sermon_series" do
      assert {:ok, %SermonSeries{} = sermon_series} = ContentEditor.create_sermon_series(@valid_attrs)
      assert sermon_series.buy_graphic_url == "some buy_graphic_url"
      assert sermon_series.description == "some description"
      assert sermon_series.graphic_url == "some graphic_url"
      assert sermon_series.passages == "some passages"
      assert sermon_series.price == 42
      assert sermon_series.released_on_string == "some released_on_string"
      assert sermon_series.title == "some title"
      assert sermon_series.uuid == "some uuid"
    end

    test "create_sermon_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentEditor.create_sermon_series(@invalid_attrs)
    end

    test "update_sermon_series/2 with valid data updates the sermon_series" do
      sermon_series = sermon_series_fixture()
      assert {:ok, sermon_series} = ContentEditor.update_sermon_series(sermon_series, @update_attrs)
      assert %SermonSeries{} = sermon_series
      assert sermon_series.buy_graphic_url == "some updated buy_graphic_url"
      assert sermon_series.description == "some updated description"
      assert sermon_series.graphic_url == "some updated graphic_url"
      assert sermon_series.passages == "some updated passages"
      assert sermon_series.price == 43
      assert sermon_series.released_on_string == "some updated released_on_string"
      assert sermon_series.title == "some updated title"
      assert sermon_series.uuid == "some updated uuid"
    end

    test "update_sermon_series/2 with invalid data returns error changeset" do
      sermon_series = sermon_series_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentEditor.update_sermon_series(sermon_series, @invalid_attrs)
      assert sermon_series == ContentEditor.get_sermon_series!(sermon_series.id)
    end

    test "delete_sermon_series/1 deletes the sermon_series" do
      sermon_series = sermon_series_fixture()
      assert {:ok, %SermonSeries{}} = ContentEditor.delete_sermon_series(sermon_series)
      assert_raise Ecto.NoResultsError, fn -> ContentEditor.get_sermon_series!(sermon_series.id) end
    end

    test "change_sermon_series/1 returns a sermon_series changeset" do
      sermon_series = sermon_series_fixture()
      assert %Ecto.Changeset{} = ContentEditor.change_sermon_series(sermon_series)
    end
  end

  describe "sermons" do
    alias Wo.ContentEditor.Sermon

    @valid_attrs %{audio_url: "some audio_url", buy_graphic_url: "some buy_graphic_url", description: "some description", passages: "some passages", price: 42, title: "some title", transcript_text: "some transcript_text", transcript_url: "some transcript_url", uuid: "some uuid"}
    @update_attrs %{audio_url: "some updated audio_url", buy_graphic_url: "some updated buy_graphic_url", description: "some updated description", passages: "some updated passages", price: 43, title: "some updated title", transcript_text: "some updated transcript_text", transcript_url: "some updated transcript_url", uuid: "some updated uuid"}
    @invalid_attrs %{audio_url: nil, buy_graphic_url: nil, description: nil, passages: nil, price: nil, title: nil, transcript_text: nil, transcript_url: nil, uuid: nil}

    def sermon_fixture(attrs \\ %{}) do
      {:ok, sermon} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentEditor.create_sermon()

      sermon
    end

    test "list_sermons/0 returns all sermons" do
      sermon = sermon_fixture()
      assert ContentEditor.list_sermons() == [sermon]
    end

    test "get_sermon!/1 returns the sermon with given id" do
      sermon = sermon_fixture()
      assert ContentEditor.get_sermon!(sermon.id) == sermon
    end

    test "create_sermon/1 with valid data creates a sermon" do
      assert {:ok, %Sermon{} = sermon} = ContentEditor.create_sermon(@valid_attrs)
      assert sermon.audio_url == "some audio_url"
      assert sermon.buy_graphic_url == "some buy_graphic_url"
      assert sermon.description == "some description"
      assert sermon.passages == "some passages"
      assert sermon.price == 42
      assert sermon.title == "some title"
      assert sermon.transcript_text == "some transcript_text"
      assert sermon.transcript_url == "some transcript_url"
      assert sermon.uuid == "some uuid"
    end

    test "create_sermon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentEditor.create_sermon(@invalid_attrs)
    end

    test "update_sermon/2 with valid data updates the sermon" do
      sermon = sermon_fixture()
      assert {:ok, sermon} = ContentEditor.update_sermon(sermon, @update_attrs)
      assert %Sermon{} = sermon
      assert sermon.audio_url == "some updated audio_url"
      assert sermon.buy_graphic_url == "some updated buy_graphic_url"
      assert sermon.description == "some updated description"
      assert sermon.passages == "some updated passages"
      assert sermon.price == 43
      assert sermon.title == "some updated title"
      assert sermon.transcript_text == "some updated transcript_text"
      assert sermon.transcript_url == "some updated transcript_url"
      assert sermon.uuid == "some updated uuid"
    end

    test "update_sermon/2 with invalid data returns error changeset" do
      sermon = sermon_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentEditor.update_sermon(sermon, @invalid_attrs)
      assert sermon == ContentEditor.get_sermon!(sermon.id)
    end

    test "delete_sermon/1 deletes the sermon" do
      sermon = sermon_fixture()
      assert {:ok, %Sermon{}} = ContentEditor.delete_sermon(sermon)
      assert_raise Ecto.NoResultsError, fn -> ContentEditor.get_sermon!(sermon.id) end
    end

    test "change_sermon/1 returns a sermon changeset" do
      sermon = sermon_fixture()
      assert %Ecto.Changeset{} = ContentEditor.change_sermon(sermon)
    end
  end
end
