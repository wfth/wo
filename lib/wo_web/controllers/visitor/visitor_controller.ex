defmodule WoWeb.Visitor.VisitorController do
  use WoWeb, :controller

  alias Wo.Account
  alias Wo.Account.User
  alias WoWeb.Session

  plug :ensure_logged_out

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"visitor" => visitor_params}) do
    case Account.create_user(visitor_params) do
      {:ok, user} ->
        {:ok, conn} = WoWeb.Session.login(conn, visitor_params)
        conn
        |> put_flash(:info, "Account created successfully. Welcome, #{user.first_name} #{user.last_name}!")
        |> redirect(to: home_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp ensure_logged_out(conn, _opts) do
    if Session.logged_in?(conn) do
      conn
      |> put_flash(:info, "You already have an account.")
      |> redirect(to: "/")
      |> halt
    else
      conn
    end
  end
end
