defmodule Wo.Web.Visitor.SlugHelper do
  import Plug.Conn

  def extract_id_from_slug(conn, _opts) do
    %{"slug" => slug} = conn.params
    id = slug |> String.split("-") |> List.first
    assign(conn, :id, id)
  end
end
