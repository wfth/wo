defmodule WoWeb.Admin.SessionController do
  use WoWeb, :controller
  alias WoWeb.Session

  plug :ensure_logged_out when not action in [:delete]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(conn, session_params) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Successfully logged in!")
        |> redirect(to: "/admin")
      {:error, conn} ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    Session.logout(conn)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: "/")
  end

  defp ensure_logged_out(conn, _opts) do
    if Session.logged_in?(conn) do
      conn
      |> put_flash(:info, "You are already logged in.")
      |> redirect(to: "/")
      |> halt
    else
      conn
    end
  end
end
