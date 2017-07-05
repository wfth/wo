defmodule Wo.SearchView do
  use Wo.Web, :view

  def search_result_html(conn, rank, [sermon_id, title, description, passages, _audio_url], id) do
    sermon = Wo.Repo.get_by!(Wo.Sermon, id: sermon_id)
    render Wo.SearchView, "sermon_result.html", conn: conn, sermon: sermon, rank: rank, title: title, description: description, passages: passages, result_id: id
  end
  def search_result_html(conn, rank, [series_id, title, description, passages], id) do
    series = Wo.Repo.get_by!(Wo.SermonSeries, id: series_id)
    render Wo.SearchView, "series_result.html", conn: conn, series: series, rank: rank, title: title, description: description, passages: passages, result_id: id
  end
end
