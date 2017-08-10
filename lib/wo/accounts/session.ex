defmodule Wo.Account.Session do
  alias Wo.Account
  alias Plug.Conn

  def login(params) do
    administrator = Account.get_administrator_by_email!(String.downcase(params["email"]))
    case authenticate(administrator, params["password"]) do
      true -> {:ok, administrator}
      _    -> :error
    end
  end

  def authenticate(administrator, password) do
    case administrator do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, administrator.crypted_password)
    end
  end

  def current_user(conn) do
    id = Conn.get_session(conn, :current_administrator)
    if id, do: Account.get_administrator!(id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
