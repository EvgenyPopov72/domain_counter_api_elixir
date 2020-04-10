defmodule DomainsCounterEx.RedisDB do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    {:ok, _conn} = Redix.start_link(opts, name: :redix)
    {:ok, "PONG"} = Redix.command(:redix, ["PING"])
  end

  def save_domains(domains) when is_list(domains) do
    ts = DateTime.utc_now() |> DateTime.to_unix()
    args = for(domain <- domains, do: [ts, domain]) |> List.flatten()
    {:ok, _} = Redix.command(:redix, ["ZADD", "domains" | args])
  end

  def get_domains(from, to) do
    {:ok, _} =
      Redix.command(
        :redix,
        ["ZRANGEBYSCORE", "domains", from, to]
      )
  end
end
