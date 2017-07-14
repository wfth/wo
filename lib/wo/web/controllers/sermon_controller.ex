defmodule Wo.Web.SermonController do
  use Wo.Web, :controller

  alias Wo.Web.Sermon
  alias Wo.Web.SermonSeries

  def index(conn, %{"sermon_series_id" => sermon_series_id}) do
    sermon_series = Repo.get!(SermonSeries, sermon_series_id)
    sermons = Repo.all(from s in Sermon, where: s.sermon_series_id == ^sermon_series.id)
    render(conn, "index.html", sermon_series_id: sermon_series.id, sermons: sermons,
      page_title: "Admin: #{sermon_series.title} - Sermons")
  end

  def new(conn, %{"sermon_series_id" => sermon_series_id}) do
    changeset =
      Repo.get_by!(SermonSeries, id: sermon_series_id)
      |> build_assoc(:sermons)
      |> Sermon.changeset(%{uuid: Ecto.UUID.generate()})

    render(conn, "new.html", changeset: changeset, sermon_series_id: sermon_series_id,
      sermon: Ecto.Changeset.apply_changes(changeset), page_title: "Admin: New Sermon")
  end

  def create(conn, %{"sermon" => sermon_params, "sermon_series_id" => sermon_series_id}) do
    changeset =
      Repo.get_by!(SermonSeries, id: sermon_series_id)
      |> build_assoc(:sermons)
      |> Sermon.changeset(sermon_params)

    case Repo.insert(changeset) do
      {:ok, _sermon} ->
        conn
        |> put_flash(:info, "Sermon created successfully.")
        |> redirect(to: sermon_series_sermon_path(conn, :index, sermon_series_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, sermon_series_id: sermon_series_id,
          sermon: Ecto.Changeset.apply_changes(changeset), page_title: "Admin: New Sermon")
    end
  end

  def show(conn, %{"id" => id}) do
    sermon = Repo.get!(Sermon, id)
    render(conn, "show.html", sermon: sermon, page_title: "Admin: #{sermon.title}")
  end

  def edit(conn, %{"id" => id}) do
    sermon = Repo.get!(Sermon, id)
    changeset = Sermon.changeset(sermon)
    render(conn, "edit.html", sermon: sermon, changeset: changeset, page_title: "Admin: Edit #{sermon.title}")
  end

  def update(conn, %{"id" => id, "sermon" => sermon_params}) do
    sermon = Repo.get!(Sermon, id)
    changeset = Sermon.changeset(sermon, sermon_params)

    case Repo.update(changeset) do
      {:ok, sermon} ->
        conn
        |> put_flash(:info, "Sermon updated successfully.")
        |> redirect(to: sermon_series_sermon_path(conn, :show, sermon.sermon_series_id, sermon))
      {:error, changeset} ->
        render(conn, "edit.html", sermon: sermon, changeset: changeset, page_title: "Admin: Edit #{sermon.title}")
    end
  end

  def delete(conn, %{"id" => id}) do
    sermon = Repo.get!(Sermon, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sermon)

    conn
    |> put_flash(:info, "Sermon deleted successfully.")
    |> redirect(to: sermon_series_sermon_path(conn, :index, sermon.sermon_series_id))
  end
end