# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :planner, Planner.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "MeG8QILBYTXe1H8EHeu6b3CzdDw7DfrwkOyE8GzlsDIJKcpdSZvsVLPeLF9XEoHm",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Planner.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Planner",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "DKe8WkHqEk+3o/DHoMVZ2QrH0Uj1geOhvSTuHQ0MkQNB4z+5WeeRbXoaFOGeoAPU",
  serializer: Planner.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
