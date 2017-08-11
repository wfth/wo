defmodule WoWeb.Plug.RenewSession do
  import Plug.Conn

  alias WoWeb.Session

  def init(opts), do: opts

  def call(conn, _opts) do
    if Session.logged_in?(conn) && !Session.expired?(conn) do
      Session.renew_session(conn)
    else
      conn
    end
  end
end
