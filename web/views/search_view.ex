defmodule Wo.SearchView do
  use Wo.Web, :view

  def matrix_at([head, tail], i) do
    [Enum.at(head, i), Enum.at(tail, i)]
  end
end
