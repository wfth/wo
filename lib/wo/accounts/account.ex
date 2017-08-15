defmodule Wo.Account do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Wo.Repo

  alias Wo.Account.Administrator
  alias Wo.Account.Visitor

  def get_user_by_email(email) do
    get_user_by_email(email, [Administrator, Visitor])
  end
  def get_user_by_email(_, []), do: nil
  def get_user_by_email(email, types) do
    [head | tail] = types
    user = Repo.get_by(head, email: email)
    if user, do: {head, user}, else: get_user_by_email(email, tail)
  end

  def get_user(type, id), do: Repo.get(type, id)

  # Administrators

  def list_administrators do
    Repo.all(Administrator)
  end

  def get_administrator!(id), do: Repo.get!(Administrator, id)

  def get_administrator_by_email!(email), do: Repo.get_by!(Administrator, email: email)

  def create_administrator(attrs \\ %{}) do
    %Administrator{}
    |> Administrator.changeset(attrs)
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(attrs["password"]))
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

  # Visitors

  def list_visitors do
    Repo.all(Visitor)
  end

  def get_visitor!(id), do: Repo.get!(Visitor, id)

  def create_visitor(attrs \\ %{}) do
    %Visitor{}
    |> Visitor.changeset(attrs)
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(attrs["password"]))
    |> Repo.insert()
  end

  def update_visitor(%Visitor{} = visitor, attrs) do
    visitor
    |> Visitor.changeset(attrs)
    |> Repo.update()
  end

  def delete_visitor(%Visitor{} = visitor) do
    Repo.delete(visitor)
  end

  def change_visitor(%Visitor{} = visitor) do
    Visitor.changeset(visitor, %{})
  end
end
