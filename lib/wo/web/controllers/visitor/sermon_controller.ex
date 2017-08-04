defmodule Wo.Web.Visitor.SermonController do
  use Wo.Web, :controller

  alias Wo.Resource
  alias Wo.Resource.SermonSeries
  alias Wo.Resource.Sermon

  import Wo.Web.Visitor.SlugHelper

  plug :extract_id_from_slug when action in [:show]

  def show(conn, _params) do
    sermon = Resource.get_sermon!(conn.assigns[:id])
    sermon_series = Resource.get_sermon_series!(sermon.sermon_series_id)
    render(conn, "show.html", sermon: sermon, sermon_series: sermon_series)
  end
end
