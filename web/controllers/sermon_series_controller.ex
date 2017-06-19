defmodule Wo.SermonSeriesController do
  use Wo.Web, :controller

  alias Wo.SermonSeries

  def index(conn, _params) do
    sermonseries = Repo.all(SermonSeries)
    render(conn, "index.html", sermonseries: sermonseries)
  end

  def new(conn, _params) do
    changeset = SermonSeries.changeset(%SermonSeries{}, %{uuid: Ecto.UUID.generate()})
    render(conn, "new.html", sermon_series: Ecto.Changeset.apply_changes(changeset), changeset: changeset)
  end

  def create(conn, %{"sermon_series" => sermon_series_params}) do
    changeset = SermonSeries.changeset(%SermonSeries{}, sermon_series_params)

    case Repo.insert(changeset) do
      {:ok, _sermon_series} ->
        conn
        |> put_flash(:info, "Sermon series created successfully.")
        |> redirect(to: sermon_series_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", sermon_series: Ecto.Changeset.apply_changes(changeset), changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    sermon_series = Repo.get!(SermonSeries, id)
    changeset = SermonSeries.changeset(sermon_series)
    render(conn, "edit.html", sermon_series: sermon_series, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sermon_series" => sermon_series_params}) do
    sermon_series = Repo.get!(SermonSeries, id)
    changeset = SermonSeries.changeset(sermon_series, sermon_series_params)

    case Repo.update(changeset) do
      {:ok, _sermon_series} ->
        conn
        |> put_flash(:info, "Sermon series updated successfully.")
        |> redirect(to: sermon_series_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", sermon_series: sermon_series, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sermon_series = Repo.get!(SermonSeries, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sermon_series)

    conn
    |> put_flash(:info, "Sermon series deleted successfully.")
    |> redirect(to: sermon_series_path(conn, :index))
  end
end
