defmodule Wo.PageController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def newsletter(conn, _params) do
    render conn, "newsletter.html", page_title: "Newsletter Signup"
  end

  def series_index(conn, _params) do
    sermon_series = Repo.all(Wo.SermonSeries)
    render(conn, "series_index.html", sermon_series: sermon_series, page_title: "Sermon Series")
  end

  def sermon_index(conn, %{"id" => sermon_series_id}) do
    try do
      sermon_series = Repo.get_by!(Wo.SermonSeries, id: sermon_series_id)
      sermons = Repo.all(from s in Wo.Sermon, where: s.sermon_series_id == ^sermon_series.id)
      render(conn, "sermon_index.html", sermon_series: sermon_series,
        sermons: sermons, page_title: sermon_series.title)
    rescue
      [Ecto.NoResultsError, Ecto.Query.CastError] -> render(put_status(conn, :not_found), Wo.ErrorView, "404.html", page_title: "404")
    end
  end

  def sermon_show(conn, %{"id" => sermon_id}) do
    try do
      sermon = Repo.get_by!(Wo.Sermon, id: sermon_id)
      sermon_series = Repo.get_by!(Wo.SermonSeries, id: sermon.sermon_series_id)
      render(conn, "sermon_show.html", sermon_series: sermon_series, sermon: sermon, page_title: sermon.title)
    rescue
      [Ecto.NoResultsError, Ecto.Query.CastError] -> render(put_status(conn, :not_found), Wo.ErrorView, "404.html", page_title: "404")
    end
  end
end
