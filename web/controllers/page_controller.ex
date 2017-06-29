defmodule Wo.PageController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def newsletter(conn, _params) do
    render conn, "newsletter.html"
  end
end
