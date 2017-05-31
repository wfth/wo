ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Wo.Repo, :manual)

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
