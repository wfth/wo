defmodule WoWeb.Visitor.NewsletterController do
  use WoWeb, :controller

  def signup(conn, _params) do
    render(conn, "signup.html")
  end
end
