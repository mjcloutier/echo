# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :echo, Echo.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "RdQ7prBLiF6rUbyJdBeQZ2zON5VqI55BKwXXHLD7YJQ1tYGDsoPvtBpCWuIpjmZW",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Echo.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :echo, Echo,
  valid_oauth_domains: ["rednovalabs.com"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Echo",
  ttl: {30, :days},
  serializer: Echo.Guardian.OAuthUserSerializer,
  secret_key: %{
    "alg" => "HS512",
    "k" => "Oi3FKPKUgTUSGsrvGYCJ6bZj3fIooiDNwA9pjTXMMzYNMbIUfHQCNS1QZ-V-cxYY8TlsBaOWaNaHk76NRpSHCw",
    "kty" => "oct",
    "use" => "sig"
  }

config :hound, driver: "phantomjs"
