defmodule WoWeb.Visitor.SermonSeriesController do
  use WoWeb, :controller

  alias Wo.Resource

  import WoWeb.Visitor.SlugHelper

  plug :extract_id_from_slug when action in [:show]

  def index(conn, _params) do
    sermon_series = Resource.list_sermon_series()
    render(conn, "index.html", sermon_series: sermon_series)
  end

  def show(conn, _params) do
    sermon_series = Resource.get_sermon_series!(conn.assigns[:id])
    sermons = Resource.list_sermons(conn.assigns[:id])

    render(conn, "show.html", sermon_series: sermon_series, sermons: sermons)
  end
end
