defmodule Wo.PageController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
