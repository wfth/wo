defmodule WoWeb.Visitor.HomeController do
  use WoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
