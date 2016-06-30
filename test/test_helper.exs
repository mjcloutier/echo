Mix.Task.run "ecto.create", ~w(-r Echo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Echo.Repo --quiet)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Echo.Repo, :manual)

