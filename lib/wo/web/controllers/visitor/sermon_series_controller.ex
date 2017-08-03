defmodule Wo.Web.Visitor.SermonSeriesController do
  use Wo.Web, :controller

  alias Wo.Resource
  alias Wo.Resource.SermonSeries

  def index(conn, _params) do
    sermon_series = Resource.list_sermon_series()
    render(conn, "index.html", sermon_series: sermon_series)
  end

  def show(conn, %{"slug" => id}) do
    sermon_series = Resource.get_sermon_series!(id)
    sermons = Resource.list_sermons(id)

    render(conn, "show.html", sermon_series: sermon_series, sermons: sermons)
  end
end
