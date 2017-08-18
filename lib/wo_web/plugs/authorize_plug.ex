defmodule WoWeb.Plug.Authorize do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias WoWeb.Session

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      Session.user(conn) && Session.user(conn).administrator -> conn
      Session.user(conn) && !Session.user(conn).administrator ->
        conn
        |> put_flash(:error, "You must be logged in as an Administrator to access that page.")
        |> redirect(to: "/")
        |> halt
      true ->
        conn
        |> put_flash(:error, "Log in as an Administrator to access that page.")
        |> redirect(to: "/login")
        |> halt
    end
  end
end
