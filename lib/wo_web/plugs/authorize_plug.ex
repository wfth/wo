defmodule WoWeb.Plug.Authorize do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias WoWeb.Session

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      Session.logged_in?(conn) && !Session.session_expired?(conn) -> conn
      Session.session_expired?(conn) ->
        Session.logout(conn)
        |> put_flash(:error, "Your session has expired. Please log in again.")
        |> redirect(to: "/admin/login")
        |> halt
      true ->
        conn
        |> put_flash(:error, "You must be logged in to access that page.")
        |> redirect(to: "/admin/login")
        |> halt
    end
  end
end
