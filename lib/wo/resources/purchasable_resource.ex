defmodule Wo.Resource.PurchasableResource do
  import Ecto.Changeset

  def put_price(changeset) do
    IO.inspect(changeset)
    case changeset.changes do
      %{float_price: fp} ->
        put_change(changeset, :price, round(fp * 100))
      %{} -> changeset
    end
  end

  def populate_float_price(struct) do
    Map.put(struct, :float_price, struct.price / 100)
  end
end
