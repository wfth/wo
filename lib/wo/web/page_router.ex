defmodule Wo.Web.PageRouter do
  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"slug" => slug}} = conn, opts) do
    to(conn, opts, Regex.run(~r/^(\d+)((-\w+)+)?$/, slug))
  end

  defp to(conn, _opts, nil) do
    raise Phoenix.Router.NoRouteError, conn: conn, router: Router
  end
  defp to(conn, opts, [_, id | _]) do
    conn = %{ conn | params: Map.merge(conn.params, %{"id" => id}) }
    Wo.Web.PageController.call(conn, Wo.Web.PageController.init(opts))
  end
end
