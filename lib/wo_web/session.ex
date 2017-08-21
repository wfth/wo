defmodule WoWeb.Session do
  import Plug.Conn

  alias Wo.Account

  def login(conn, params) do
    user = Account.get_user_by_email(String.downcase(get(params, :email)))
    if authenticate(user, get(params, :password)) do
      {:ok, conn
            |> put_session(:current_user, user.id)}
    else
      {:error, conn}
    end
  end

  def logout(conn) do
    conn
    |> delete_session(:current_user)
  end

  def authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def user(conn) do
    if user_id(conn), do: Account.get_user(user_id(conn))
  end

  def logged_in?(conn) do
    !!user_id(conn)
  end

  defp get(map, key) when is_atom(key), do: map[key] || map[Atom.to_string(key)]
  defp user_id(conn), do: get_session(conn, :current_user)

  alias Wo.Carts

  def put_cart(conn, cart) do
    conn |> put_session(:cart, cart.id)
  end

  def cart(conn) do
    if get_session(conn, :cart), do: Carts.get_cart(get_session(conn, :cart))
  end
end
