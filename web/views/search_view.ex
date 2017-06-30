defmodule Wo.SearchView do
  use Wo.Web, :view

  def search_result_html(rank, [title, description, passages, audio_url], id) do
    render Wo.SearchView, "sermon_result.html", rank: rank, title: title, description: description, passages: passages, audio_url: audio_url, result_id: id
  end
  def search_result_html(rank, [title, description, passages], id) do
    render Wo.SearchView, "series_result.html", rank: rank, title: title, description: description, passages: passages, result_id: id
  end
end
