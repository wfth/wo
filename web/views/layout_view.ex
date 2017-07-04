defmodule Wo.LayoutView do
  use Wo.Web, :view

  def flash_callout_tag(_, nil), do: ""
  def flash_callout_tag(:info, value), do: content_tag(:p, value, class: "callout primary")
  def flash_callout_tag(:warn, value), do: content_tag(:p, value, class: "callout warning")
  def flash_callout_tag(conn) do
    Enum.reduce([:info, :warn], [], fn(key, acc) -> acc ++ [flash_callout_tag(key, get_flash(conn, key))] end)
  end

  def nav_link(conn, text, path) do
    class = if conn.request_path == path, do: "active", else: ""
    content_tag(:li, link(text, to: path), class: class)
  end
end
