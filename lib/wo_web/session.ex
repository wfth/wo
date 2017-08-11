defmodule WoWeb.Session do
  alias Wo.Account
  import Plug.Conn

  def login(conn, params) do
    administrator = Account.get_administrator_by_email!(String.downcase(params["email"]))
    if authenticate(administrator, params["password"]) do
      {:ok, conn
            |> put_session(:current_administrator, administrator.id)
            |> renew_session()}
    else
      {:error, conn}
    end
  end

  def logout(conn) do
    conn
    |> delete_session(:current_administrator)
    |> delete_session(:expires_at)
  end

  def authenticate(administrator, password) do
    case administrator do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, administrator.crypted_password)
    end
  end

  def renew_session(conn) do
    put_session(conn, :expires_at, expires_at())
  end

  def administrator(conn) do
    id = get_session(conn, :current_administrator)
    if id, do: Account.get_administrator!(id)
  end

  def logged_in?(conn), do: !!administrator(conn)

  def expired?(conn) do
    session_expiration = get_session(conn, :expires_at)
    case Timex.parse(session_expiration, "%FT%T%:z", :strftime) do
      {:ok, expires_at} -> Timex.after?(Timex.now, Timex.parse!(session_expiration, "%FT%T%:z", :strftime))
      {:error, _} -> true
    end
  end

  defp expires_at do
    Timex.now |> Timex.shift(hours: 1) |> Timex.format!("%FT%T%:z", :strftime)
  end
end
