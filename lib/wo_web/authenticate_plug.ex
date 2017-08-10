defmodule WoWeb.Plug.Authenticate do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Wo.Account.Session, only: [logged_in?: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page.")
      |> redirect(to: "/admin/login")
      |> halt
    end
  end
end
