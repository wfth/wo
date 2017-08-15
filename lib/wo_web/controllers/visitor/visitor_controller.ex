defmodule WoWeb.Visitor.VisitorController do
  use WoWeb, :controller

  alias Wo.Account
  alias Wo.Account.Visitor

  def new(conn, _params) do
    changeset = Account.change_visitor(%Visitor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"visitor" => visitor_params}) do
    case Account.create_visitor(visitor_params) do
      {:ok, visitor} ->
        {:ok, conn} = WoWeb.Session.login(conn, Visitor, visitor_params)
        conn
        |> put_flash(:info, "Account created successfully. Welcome, #{visitor.first_name} #{visitor.last_name}!")
        |> redirect(to: home_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
