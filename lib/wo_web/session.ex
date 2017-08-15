defmodule WoWeb.Session do
  alias Wo.Account
  import Plug.Conn

  alias Wo.Account.Administrator
  alias Wo.Account.Visitor

  def login(conn, type, params) do
    if !!logged_in_user_type(conn), do: {:error, conn}

    user = Account.get_user_by_email(type, String.downcase(params["email"]))
    if authenticate(user, params["password"]) do
      {:ok, conn
            |> put_session(:current_user, user.id)
            |> put_session(:user_type, type)
            |> renew_session()}
    else
      {:error, conn}
    end
  end

  def logout(conn) do
    conn
    |> delete_session(:current_user)
    |> delete_session(:expires_at)
    |> delete_session(:user_type)
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
    if user_id(conn) do
      case Account.get_user(type(conn), user_id(conn)) do
        user -> user
        _    -> nil
      end
    end
  end

  def logged_in_user_type(conn) do
    type(conn)
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

  defp type(conn), do: get_session(conn, :user_type)
  defp user_id(conn), do: get_session(conn, :current_user)
  defp expires_at(conn), do: get_session(conn, :expires_at)
end
