use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :echo, Echo.Endpoint,
  http: [port: 4001],
  server: true

config :guardian, Guardian,
  serializer: Echo.TestGuardianSerializer

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :echo, Echo.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "circle_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
