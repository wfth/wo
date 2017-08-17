defmodule WoWeb.Plug.Authorize do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias WoWeb.Session

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      Session.user(conn).administrator && !Session.expired?(conn) -> conn
      !Session.user(conn).administrator ->
        conn
        |> put_flash(:error, "You must be logged in as an Administrator to access that page.")
        |> redirect(to: "/")
        |> halt
      Session.expired?(conn) ->
        Session.logout(conn)
        |> put_flash(:error, "Your session has expired. Please log in again.")
        |> redirect(to: "/admin/login")
        |> halt
      true ->
        conn
        |> put_flash(:error, "Log in as an Administrator to access that page.")
        |> redirect(to: "/admin/login")
        |> halt
    end
  end
end
