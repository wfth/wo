defmodule Wo.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Wo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wo.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Wo.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Wo.Repo, {:shared, self()})
    end

    :ok
  end
end
