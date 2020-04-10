use Mix.Config

# Configure your database
config :domains_counter_ex,
  redis_uri: "redis://localhost:6379/0"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :domains_counter_ex, DomainsCounterExWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
