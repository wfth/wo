defmodule WoWeb.FallbackController do
  use WoWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_flash(:error, humanize_errors(changeset))
    |> redirect(to: cart_path(conn, :show))
  end

  defp humanize_errors(changeset) do
    Enum.map(changeset.errors, fn {field, {message, _opts}} ->
      "#{Phoenix.Naming.humanize(field)} #{message}."
    end) |> Enum.join(" ")
  end
end
