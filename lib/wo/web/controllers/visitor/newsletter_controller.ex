defmodule Wo.Web.Visitor.NewsletterController do
  use Wo.Web, :controller

  def signup(conn, _params) do
    render(conn, "signup.html")
  end
end
