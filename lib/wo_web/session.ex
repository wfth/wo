defmodule WoWeb.Session do
  alias Wo.Account
  import Plug.Conn

  def login(conn, params) do
    user = Account.get_user_by_email(String.downcase(params["email"]))
    if authenticate(user, params["password"]) do
      {:ok, conn
            |> put_session(:current_user, user.id)
            |> renew_session()}
    else
      {:error, conn}
    end
  end

  def logout(conn) do
    conn
    |> delete_session(:current_user)
    |> delete_session(:expires_at)
  end

  def authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def renew_session(conn) do
    put_session(conn, :expires_at, expires_at())
  end

  def user(conn) do
    if user_id(conn), do: Account.get_user(user_id(conn))
  end

  def logged_in?(conn) do
    !!user_id(conn)
  end

  def expired?(conn) do
    case Timex.parse(expires_at(conn), "%FT%T%:z", :strftime) do
      {:ok, expires_at} -> Timex.after?(Timex.now, expires_at)
      {:error, _} -> true
    end
  end

  defp expires_at do
    Timex.now |> Timex.shift(hours: 1) |> Timex.format!("%FT%T%:z", :strftime)
  end

  defp user_id(conn), do: get_session(conn, :current_user)
  defp expires_at(conn), do: get_session(conn, :expires_at)
end
