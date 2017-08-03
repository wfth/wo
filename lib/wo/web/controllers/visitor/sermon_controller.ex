defmodule Wo.Web.Visitor.SermonController do
  use Wo.Web, :controller

  alias Wo.Resource
  alias Wo.Resource.SermonSeries
  alias Wo.Resource.Sermon

  def show(conn, %{"slug" => id}) do
    sermon = Resource.get_sermon!(id)
    render(conn, "show.html", sermon: sermon)
  end
end
