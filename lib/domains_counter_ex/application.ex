defmodule DomainsCounterEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    repo_opts = Application.get_env(:domains_counter_ex, :redis_uri)

    children = [
      # Start the Ecto repository
      {DomainsCounterEx.RedisDB, repo_opts},
      # Start the endpoint when the application starts
      DomainsCounterExWeb.Endpoint
      # Starts a worker by calling: DomainsCounterEx.Worker.start_link(arg)
      # {DomainsCounterEx.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DomainsCounterEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DomainsCounterExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
