defmodule WoWeb.TemplateHelpers do
  use Phoenix.HTML

  import WoWeb.Router.Helpers

  # Read S3 object key from a URL
  def key_from_url(nil), do: nil
  def key_from_url(url) do
    url_parts = String.split(url, "/")
    url_parts -- Enum.take(url_parts, 3)
    |> Enum.join("/")
  end

  def add_to_cart_link(conn, struct) do
    {_, resource_type} = struct.__meta__.source

    link "Add to Cart", to: cart_item_path(conn, :create, resource_type: resource_type,
      resource_id: struct.id, redirect_to: conn.request_path),
      method: :post, class: "button"
  end

  def display(price) when is_integer(price) do
    :erlang.float_to_binary(price/100, decimals: 2)
  end
end
