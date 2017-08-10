defmodule Wo.Account do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Wo.Repo

  alias Wo.Account.Administrator

  def list_administrators do
    Repo.all(Administrator)
  end

  def get_administrator!(id), do: Repo.get!(Administrator, id)

  def get_administrator_by_email!(email), do: Repo.get_by!(Administrator, email: email)

  def create_administrator(attrs \\ %{}) do
    %Administrator{}
    |> Administrator.changeset(attrs)
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(attrs[:password]))
    |> Repo.insert()
  end

  def update_administrator(%Administrator{} = administrator, attrs) do
    administrator
    |> Administrator.changeset(attrs)
    |> Repo.update()
  end

  def delete_administrator(%Administrator{} = administrator) do
    Repo.delete(administrator)
  end

  def change_administrator(%Administrator{} = administrator) do
    Administrator.changeset(administrator, %{})
  end
end
