ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Planner.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Planner.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Planner.Repo)

