defmodule Wo.SermonControllerTest do
  use Wo.ConnCase

  alias Wo.Sermon
  @valid_attrs %{audio_key: "some content", buy_graphic_key: "some content", description: "some content", passage: "some content", price: "120.5", sermon_series_id: 42, title: "some content", transcript_key: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sermon_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sermons"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, sermon_path(conn, :new)
    assert html_response(conn, 200) =~ "New sermon"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, sermon_path(conn, :create), sermon: @valid_attrs
    assert redirected_to(conn) == sermon_path(conn, :index)
    assert Repo.get_by(Sermon, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sermon_path(conn, :create), sermon: @invalid_attrs
    assert html_response(conn, 200) =~ "New sermon"
  end

  test "shows chosen resource", %{conn: conn} do
    sermon = Repo.insert! %Sermon{}
    conn = get conn, sermon_path(conn, :show, sermon)
    assert html_response(conn, 200) =~ "Show sermon"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sermon_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    sermon = Repo.insert! %Sermon{}
    conn = get conn, sermon_path(conn, :edit, sermon)
    assert html_response(conn, 200) =~ "Edit sermon"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    sermon = Repo.insert! %Sermon{}
    conn = put conn, sermon_path(conn, :update, sermon), sermon: @valid_attrs
    assert redirected_to(conn) == sermon_path(conn, :show, sermon)
    assert Repo.get_by(Sermon, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sermon = Repo.insert! %Sermon{}
    conn = put conn, sermon_path(conn, :update, sermon), sermon: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit sermon"
  end

  test "deletes chosen resource", %{conn: conn} do
    sermon = Repo.insert! %Sermon{}
    conn = delete conn, sermon_path(conn, :delete, sermon)
    assert redirected_to(conn) == sermon_path(conn, :index)
    refute Repo.get(Sermon, sermon.id)
  end
end
