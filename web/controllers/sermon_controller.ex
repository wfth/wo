defmodule Wo.SermonController do
  use Wo.Web, :controller

  alias Wo.Sermon
  alias Wo.SermonSeries

  def index(conn, _params) do
    sermons = Repo.all(Sermon)
    render(conn, "index.html", sermons: sermons)
  end

  def new(conn, %{"sermon_series_id" => sermon_series_id}) do
    changeset =
      Repo.get_by!(SermonSeries, id: sermon_series_id)
      |> build_assoc(:sermons)
      |> Sermon.changeset()

    render(conn, "new.html", changeset: changeset)
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
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sermon = Repo.get!(Sermon, id)
    render(conn, "show.html", sermon: sermon)
  end

  def edit(conn, %{"id" => id}) do
    sermon = Repo.get!(Sermon, id)
    changeset = Sermon.changeset(sermon)
    render(conn, "edit.html", sermon: sermon, changeset: changeset)
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
        render(conn, "edit.html", sermon: sermon, changeset: changeset)
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
