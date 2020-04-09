# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :domains_counter_ex,
  ecto_repos: [DomainsCounterEx.Repo]

# Configures the endpoint
config :domains_counter_ex, DomainsCounterExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iZgFkuWrGR8OLyuHWSpYnnhuI04PToD+C7K4tM/G9LK371KVYhjRmU5CK9c3h+Uj",
  render_errors: [view: DomainsCounterExWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DomainsCounterEx.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "c0T3Po9a"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
