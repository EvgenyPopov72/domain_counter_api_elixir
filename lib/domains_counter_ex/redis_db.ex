defmodule DomainsCounterEx.RedisDB do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    {:ok, _conn} = Redix.start_link(opts, name: :redix)
    {:ok, "PONG"} = Redix.command(:redix, ["PING"])
  end

  def handle_call({:save_domains, domains}, _from, opts)do
    ts = DateTime.utc_now() |> DateTime.to_unix()
    args = for(domain <- domains, do: [ts, domain]) |> List.flatten()
    {:ok, result} = Redix.command(:redix, ["ZADD", "domains" | args])
    {:reply, result, opts}
  end

  def handle_call({:get_domains, from, to}, _from, opts) do
    {:ok, domains} =
      Redix.command(
        :redix,
        ["ZRANGEBYSCORE", "domains", from, to]
      )
    {:reply, domains, opts}
  end

  def save_domains(domains) when is_list(domains) do
    GenServer.call(__MODULE__, {:save_domains, domains})
  end

  def get_domains(from, to) do
    GenServer.call(__MODULE__, {:get_domains, from, to})
  end
end
