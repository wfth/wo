defmodule Wo.Web.Admin.SermonController do
  use Wo.Web, :controller

  alias Wo.ContentEditor
  alias Wo.ContentEditor.SermonSeries
  alias Wo.ContentEditor.Sermon

  def index(conn, %{"sermon_series_id" => sermon_series_id}) do
    sermon_series = ContentEditor.get_sermon_series!(sermon_series_id)
    sermons = ContentEditor.list_sermons(sermon_series.id)

    render(conn, "index.html", sermon_series_id: sermon_series.id, sermons: sermons,
      page_title: "Admin: #{sermon_series.title} - Sermons")
  end

  def new(conn, %{"sermon_series_id" => sermon_series_id}) do
    sermon_series = ContentEditor.get_sermon_series!(sermon_series_id)
    changeset = ContentEditor.change_sermon(%Sermon{uuid: Ecto.UUID.generate()})

    render(conn, "new.html", changeset: changeset, sermon_series_id: sermon_series_id,
      sermon: Ecto.Changeset.apply_changes(changeset), page_title: "Admin: New Sermon")
  end

  def create(conn, %{"sermon" => sermon_params, "sermon_series_id" => sermon_series_id}) do
    sermon_series = ContentEditor.get_sermon_series!(sermon_series_id)

    case ContentEditor.create_sermon(%Sermon{}, sermon_series, sermon_params) do
      {:ok, _sermon} ->
        conn
        |> put_flash(:info, "Sermon created successfully.")
        |> redirect(to: admin_sermon_series_sermon_path(conn, :index, sermon_series_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, sermon_series_id: sermon_series_id,
          sermon: Ecto.Changeset.apply_changes(changeset), page_title: "Admin: New Sermon")
    end
  end

  def show(conn, %{"id" => id}) do
    sermon = ContentEditor.get_sermon!(id)
    render(conn, "show.html", sermon: sermon, page_title: "Admin: #{sermon.title}")
  end

  def edit(conn, %{"id" => id}) do
    sermon = ContentEditor.get_sermon!(id)
    changeset = ContentEditor.change_sermon(sermon)

    render(conn, "edit.html", sermon: sermon, changeset: changeset, page_title: "Admin: Edit #{sermon.title}")
  end

  def update(conn, %{"id" => id, "sermon" => sermon_params}) do
    sermon = Repo.get!(Sermon, id)
    changeset = Sermon.changeset(sermon, sermon_params)

    case Repo.update(changeset) do
      {:ok, sermon} ->
        conn
        |> put_flash(:info, "Sermon updated successfully.")
        |> redirect(to: admin_sermon_series_sermon_path(conn, :show, sermon.sermon_series_id, sermon))
      {:error, changeset} ->
        render(conn, "edit.html", sermon: sermon, changeset: changeset, page_title: "Admin: Edit #{sermon.title}")
    end
  end

  def delete(conn, %{"id" => id}) do
    sermon = ContentEditor.get_sermon!(id)
    ContentEditor.delete_sermon(sermon)

    conn
    |> put_flash(:info, "Sermon deleted successfully.")
    |> redirect(to: admin_sermon_series_sermon_path(conn, :index, sermon.sermon_series_id))
  end
end
