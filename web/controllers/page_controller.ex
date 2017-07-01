defmodule Wo.PageController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def newsletter(conn, _params) do
    render conn, "newsletter.html"
  end

  def series_index(conn, _params) do
    sermon_series = Repo.all(Wo.SermonSeries)
    render(conn, "series_index.html", sermon_series: sermon_series)
  end

  def sermon_index(conn, %{"slug" => slug}) do
    [sermon_series_id | _slug] = String.split(slug, "-")
    try do
      sermon_series = Repo.get_by!(Wo.SermonSeries, id: sermon_series_id)
      sermons = Repo.all(from s in Wo.Sermon, where: s.sermon_series_id == ^sermon_series.id)
      render(conn, "sermon_index.html", sermons: sermons)
    rescue
      e in [Ecto.NoResultsError, Ecto.Query.CastError] -> render(put_status(conn, :not_found), Wo.ErrorView, "404.html")
    end
  end

  def sermon_show(conn, %{"slug" => slug}) do
    [sermon_id | _slug] = String.split(slug, "-")
    try do
      sermon = Repo.get_by!(Wo.Sermon, id: sermon_id)
      sermon_series = Repo.get_by!(Wo.SermonSeries, id: sermon.sermon_series_id)
      render(conn, "sermon_show.html", sermon_series: sermon_series, sermon: sermon)
    rescue
      e in [Ecto.NoResultsError, Ecto.Query.CastError] -> render(put_status(conn, :not_found), Wo.ErrorView, "404.html")
    end
  end
end
