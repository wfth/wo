defmodule Wo.Resource.PurchasableResource do
  import Ecto.Changeset

  def put_price(changeset) do
    case changeset.changes do
      %{float_price: nil} -> changeset
      %{float_price: fp} -> put_change(changeset, :price, round(fp * 100))
      _ -> changeset
    end
  end

  def populate_float_price(data, preload_field \\ nil) do
    if is_list(data), do: _populate_float_price(data, preload_field, []),
      else: _populate_float_price(data, preload_field)
  end
  def _populate_float_price(struct, nil) do
    Map.put(struct, :float_price, struct.price / 100)
  end
  def _populate_float_price(struct, preload_field) do
    struct = _populate_float_price(struct, nil)
    internal_struct = Map.get(struct, preload_field, %{})
    populated_internal_struct = Map.put(internal_struct, :float_price, internal_struct.price / 100)
    Map.put(struct, preload_field, populated_internal_struct)
  end
  def _populate_float_price([], _, populated_structs), do: populated_structs
  def _populate_float_price([head | tail], preload_field, acc) do
    head = _populate_float_price(head, preload_field)
    _populate_float_price(tail, preload_field, acc ++ [head])
  end
end
