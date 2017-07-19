defmodule Wo.ContentBrowserTest do
  use Wo.DataCase

  alias Wo.ContentBrowser

  describe "sermon_series" do
    alias Wo.ContentBrowser.SermonSeries

    @valid_attrs %{buy_graphic_url: "some buy_graphic_url", description: "some description", graphic_url: "some graphic_url", passages: "some passages", price: 42, released_on_string: "some released_on_string", title: "some title"}
    @update_attrs %{buy_graphic_url: "some updated buy_graphic_url", description: "some updated description", graphic_url: "some updated graphic_url", passages: "some updated passages", price: 43, released_on_string: "some updated released_on_string", title: "some updated title"}
    @invalid_attrs %{buy_graphic_url: nil, description: nil, graphic_url: nil, passages: nil, price: nil, released_on_string: nil, title: nil}

    def sermon_series_fixture(attrs \\ %{}) do
      {:ok, sermon_series} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentBrowser.create_sermon_series()

      sermon_series
    end

    test "list_sermon_series/0 returns all sermon_series" do
      sermon_series = sermon_series_fixture()
      assert ContentBrowser.list_sermon_series() == [sermon_series]
    end

    test "get_sermon_series!/1 returns the sermon_series with given id" do
      sermon_series = sermon_series_fixture()
      assert ContentBrowser.get_sermon_series!(sermon_series.id) == sermon_series
    end

    test "create_sermon_series/1 with valid data creates a sermon_series" do
      assert {:ok, %SermonSeries{} = sermon_series} = ContentBrowser.create_sermon_series(@valid_attrs)
      assert sermon_series.buy_graphic_url == "some buy_graphic_url"
      assert sermon_series.description == "some description"
      assert sermon_series.graphic_url == "some graphic_url"
      assert sermon_series.passages == "some passages"
      assert sermon_series.price == 42
      assert sermon_series.released_on_string == "some released_on_string"
      assert sermon_series.title == "some title"
    end

    test "create_sermon_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.create_sermon_series(@invalid_attrs)
    end

    test "update_sermon_series/2 with valid data updates the sermon_series" do
      sermon_series = sermon_series_fixture()
      assert {:ok, sermon_series} = ContentBrowser.update_sermon_series(sermon_series, @update_attrs)
      assert %SermonSeries{} = sermon_series
      assert sermon_series.buy_graphic_url == "some updated buy_graphic_url"
      assert sermon_series.description == "some updated description"
      assert sermon_series.graphic_url == "some updated graphic_url"
      assert sermon_series.passages == "some updated passages"
      assert sermon_series.price == 43
      assert sermon_series.released_on_string == "some updated released_on_string"
      assert sermon_series.title == "some updated title"
    end

    test "update_sermon_series/2 with invalid data returns error changeset" do
      sermon_series = sermon_series_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.update_sermon_series(sermon_series, @invalid_attrs)
      assert sermon_series == ContentBrowser.get_sermon_series!(sermon_series.id)
    end

    test "delete_sermon_series/1 deletes the sermon_series" do
      sermon_series = sermon_series_fixture()
      assert {:ok, %SermonSeries{}} = ContentBrowser.delete_sermon_series(sermon_series)
      assert_raise Ecto.NoResultsError, fn -> ContentBrowser.get_sermon_series!(sermon_series.id) end
    end

    test "change_sermon_series/1 returns a sermon_series changeset" do
      sermon_series = sermon_series_fixture()
      assert %Ecto.Changeset{} = ContentBrowser.change_sermon_series(sermon_series)
    end
  end

  describe "sermons" do
    alias Wo.ContentBrowser.Sermon

    @valid_attrs %{audio_url: "some audio_url", buy_graphic_url: "some buy_graphic_url", description: "some description", passages: "some passages", price: 42, title: "some title", transcript_text: "some transcript_text", transcript_url: "some transcript_url"}
    @update_attrs %{audio_url: "some updated audio_url", buy_graphic_url: "some updated buy_graphic_url", description: "some updated description", passages: "some updated passages", price: 43, title: "some updated title", transcript_text: "some updated transcript_text", transcript_url: "some updated transcript_url"}
    @invalid_attrs %{audio_url: nil, buy_graphic_url: nil, description: nil, passages: nil, price: nil, title: nil, transcript_text: nil, transcript_url: nil}

    def sermon_fixture(attrs \\ %{}) do
      {:ok, sermon} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentBrowser.create_sermon()

      sermon
    end

    test "list_sermons/0 returns all sermons" do
      sermon = sermon_fixture()
      assert ContentBrowser.list_sermons() == [sermon]
    end

    test "get_sermon!/1 returns the sermon with given id" do
      sermon = sermon_fixture()
      assert ContentBrowser.get_sermon!(sermon.id) == sermon
    end

    test "create_sermon/1 with valid data creates a sermon" do
      assert {:ok, %Sermon{} = sermon} = ContentBrowser.create_sermon(@valid_attrs)
      assert sermon.audio_url == "some audio_url"
      assert sermon.buy_graphic_url == "some buy_graphic_url"
      assert sermon.description == "some description"
      assert sermon.passages == "some passages"
      assert sermon.price == 42
      assert sermon.title == "some title"
      assert sermon.transcript_text == "some transcript_text"
      assert sermon.transcript_url == "some transcript_url"
    end

    test "create_sermon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.create_sermon(@invalid_attrs)
    end

    test "update_sermon/2 with valid data updates the sermon" do
      sermon = sermon_fixture()
      assert {:ok, sermon} = ContentBrowser.update_sermon(sermon, @update_attrs)
      assert %Sermon{} = sermon
      assert sermon.audio_url == "some updated audio_url"
      assert sermon.buy_graphic_url == "some updated buy_graphic_url"
      assert sermon.description == "some updated description"
      assert sermon.passages == "some updated passages"
      assert sermon.price == 43
      assert sermon.title == "some updated title"
      assert sermon.transcript_text == "some updated transcript_text"
      assert sermon.transcript_url == "some updated transcript_url"
    end

    test "update_sermon/2 with invalid data returns error changeset" do
      sermon = sermon_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.update_sermon(sermon, @invalid_attrs)
      assert sermon == ContentBrowser.get_sermon!(sermon.id)
    end

    test "delete_sermon/1 deletes the sermon" do
      sermon = sermon_fixture()
      assert {:ok, %Sermon{}} = ContentBrowser.delete_sermon(sermon)
      assert_raise Ecto.NoResultsError, fn -> ContentBrowser.get_sermon!(sermon.id) end
    end

    test "change_sermon/1 returns a sermon changeset" do
      sermon = sermon_fixture()
      assert %Ecto.Changeset{} = ContentBrowser.change_sermon(sermon)
    end
  end

  describe "search_documents" do
    alias Wo.ContentBrowser.SearchDocument

    @valid_attrs %{content: "some content", document_id: 42, document_table: "some document_table"}
    @update_attrs %{content: "some updated content", document_id: 43, document_table: "some updated document_table"}
    @invalid_attrs %{content: nil, document_id: nil, document_table: nil}

    def search_document_fixture(attrs \\ %{}) do
      {:ok, search_document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentBrowser.create_search_document()

      search_document
    end

    test "list_search_documents/0 returns all search_documents" do
      search_document = search_document_fixture()
      assert ContentBrowser.list_search_documents() == [search_document]
    end

    test "get_search_document!/1 returns the search_document with given id" do
      search_document = search_document_fixture()
      assert ContentBrowser.get_search_document!(search_document.id) == search_document
    end

    test "create_search_document/1 with valid data creates a search_document" do
      assert {:ok, %SearchDocument{} = search_document} = ContentBrowser.create_search_document(@valid_attrs)
      assert search_document.content == "some content"
      assert search_document.document_id == 42
      assert search_document.document_table == "some document_table"
    end

    test "create_search_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.create_search_document(@invalid_attrs)
    end

    test "update_search_document/2 with valid data updates the search_document" do
      search_document = search_document_fixture()
      assert {:ok, search_document} = ContentBrowser.update_search_document(search_document, @update_attrs)
      assert %SearchDocument{} = search_document
      assert search_document.content == "some updated content"
      assert search_document.document_id == 43
      assert search_document.document_table == "some updated document_table"
    end

    test "update_search_document/2 with invalid data returns error changeset" do
      search_document = search_document_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentBrowser.update_search_document(search_document, @invalid_attrs)
      assert search_document == ContentBrowser.get_search_document!(search_document.id)
    end

    test "delete_search_document/1 deletes the search_document" do
      search_document = search_document_fixture()
      assert {:ok, %SearchDocument{}} = ContentBrowser.delete_search_document(search_document)
      assert_raise Ecto.NoResultsError, fn -> ContentBrowser.get_search_document!(search_document.id) end
    end

    test "change_search_document/1 returns a search_document changeset" do
      search_document = search_document_fixture()
      assert %Ecto.Changeset{} = ContentBrowser.change_search_document(search_document)
    end
  end
end
