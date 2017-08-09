defmodule WoWeb.Visitor.SearchView do
  use WoWeb, :view

  alias Wo.Resource

  def search_result_html(conn, rank, [sermon_id, title, description, passages, _audio_url], id) do
    sermon = Resource.get_sermon!(sermon_id)
    render WoWeb.Visitor.SearchView, "sermon_result.html", conn: conn, sermon: sermon,
      rank: rank, title: title, description: description, passages: passages,
      result_id: id
  end
  def search_result_html(conn, rank, [series_id, title, description, passages], id) do
    series = Resource.get_sermon!(series_id)
    render WoWeb.Visitor.SearchView, "series_result.html", conn: conn, series: series,
      rank: rank, title: title, description: description, passages: passages,
      result_id: id
  end
end
