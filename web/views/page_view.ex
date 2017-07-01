defmodule Wo.PageView do
  use Wo.Web, :view

  def slug(id, title) do
    "#{id}-" <> (title |>
      String.downcase |>
      String.strip |>
      String.replace(~r/[ :]/, "-") |>
      String.replace(~r/[^A-Za-z0-9-]/, "") |>
      String.replace(~r/-+/, "-"))
  end
end
