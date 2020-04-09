defmodule DomainsCounterEx.Repo do
  use Ecto.Repo,
    otp_app: :domains_counter_ex,
    adapter: Ecto.Adapters.Postgres
end
