Application.ensure_all_started(:hound)
ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Echo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Echo.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Echo.Repo, :manual)

