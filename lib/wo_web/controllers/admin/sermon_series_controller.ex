defmodule WoWeb.Admin.SermonSeriesController do
  use WoWeb, :controller

  alias Wo.Resource
  alias Wo.Resource.SermonSeries

  def index(conn, _params) do
    sermon_series = Resource.list_sermon_series
    render(conn, "index.html", sermon_series: sermon_series, page_title: "Admin: Sermon Series")
  end

  def new(conn, _params) do
    changeset = Resource.change_sermon_series(%SermonSeries{uuid: Ecto.UUID.generate()})
    render(conn, "new.html", sermon_series: Ecto.Changeset.apply_changes(changeset),
      changeset: changeset, page_title: "Admin: New Sermon Series")
  end

  def create(conn, %{"sermon_series" => sermon_series_params}) do
    case Resource.create_sermon_series(sermon_series_params) do
      {:ok, _sermon_series} ->
        conn
        |> put_flash(:info, "Sermon series created successfully.")
        |> redirect(to: admin_sermon_series_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", sermon_series: Ecto.Changeset.apply_changes(changeset), changeset: changeset,
          page_title: "Admin: New Sermon Series")
    end
  end

  def edit(conn, %{"id" => id}) do
    sermon_series = Resource.get_sermon_series!(id)
    changeset = Resource.change_sermon_series(sermon_series)
    render(conn, "edit.html", sermon_series: sermon_series, changeset: changeset,
      page_title: "Admin: Edit #{sermon_series.title}")
  end

  def update(conn, %{"id" => id, "sermon_series" => sermon_series_params}) do
    sermon_series = Resource.get_sermon_series!(id)
    case Resource.update_sermon_series(sermon_series, sermon_series_params) do
      {:ok, _sermon_series} ->
        conn
        |> put_flash(:info, "Sermon series updated successfully.")
        |> redirect(to: admin_sermon_series_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", sermon_series: sermon_series, changeset: changeset,
          page_title: "Admin: Edit #{sermon_series.title}")
    end
  end

  def delete(conn, %{"id" => id}) do
    sermon_series = Resource.get_sermon_series!(id)
    Resource.delete_sermon_series(sermon_series)

    conn
    |> put_flash(:info, "Sermon series deleted successfully.")
    |> redirect(to: admin_sermon_series_path(conn, :index))
  end
end
