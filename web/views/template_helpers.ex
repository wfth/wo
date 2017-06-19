defmodule Wo.TemplateHelpers do
  use Phoenix.HTML

  def key_from_url(nil), do: nil
  def key_from_url(url) do
    url_parts = String.split(url, "/")
    url_parts -- Enum.take(url_parts, 3)
    |> Enum.join("/")
  end
end
