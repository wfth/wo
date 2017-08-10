defmodule WoWeb.Admin.SessionController do
  use WoWeb, :controller
  import Wo.Account.Session, only: [logged_in?: 1]

  plug :ensure_logged_out when not action in [:delete]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Wo.Account.Session.login(session_params) do
      {:ok, administrator} ->
        conn
        |> put_session(:current_administrator, administrator.id)
        |> put_flash(:info, "Successfully logged in!")
        |> redirect(to: "/admin")
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_administrator)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: "/")
  end

  defp ensure_logged_out(conn, _opts) do
    if logged_in?(conn) do
      conn
      |> put_flash(:info, "You are already logged in.")
      |> redirect(to: "/")
      |> halt
    else
      conn
    end
  end
end
