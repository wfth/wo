defmodule Wo.SearchView do
  use Wo.Web, :view

  def matrix_at(list, i) do
    [Enum.at(Enum.at(list, 0), i), Enum.at(Enum.at(list, 1), i)]
  end
end
