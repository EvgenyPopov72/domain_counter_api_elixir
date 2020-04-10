defmodule DomainsCounterExWeb.DomainController do
  alias DomainsCounterEx.RedisDB
  require Logger
  use DomainsCounterExWeb, :controller

  action_fallback DomainsCounterExWeb.FallbackController

  defp link_to_domain(link) when is_bitstring(link) do
    uri = URI.parse(link)
    uri.authority || uri.path
  end

  def save_links(conn, %{"links" => links}) when is_list(links) do
    domains = for link <- links, do: link_to_domain(link)
    {:ok, result} = RedisDB.save_domains(domains)
    Logger.debug("save_links: #{inspect(result)}")

    render(
      conn,
      "save_links.json",
      result: %{
        "result" => "ok"
      }
    )
  end

  def save_links(conn, params) do
    conn
        |> put_status(400)
        |> put_view(DomainsCounterExWeb.ErrorView)
        |> render("400.json",
             %{message: "#{inspect(params)} - is not a list"})
  end

  def show_domains(conn, %{"from" => from, "to" => to}) do
    try do
      {_from, ""} = Float.parse(from)
      {_to, ""} = Float.parse(to)
    rescue
      MatchError ->
      conn
        |> put_status(400)
        |> put_view(DomainsCounterExWeb.ErrorView)
        |> render("400.json",
             %{message: "Params 'from', 'to' are not a numbers"})
    end

    {:ok, domains} = RedisDB.get_domains(from, to)
    render(
      conn,
      "show_domains.json",
      result: %{
        "domains" => domains,
        "status" => "ok",
      }
    )
  end

  def show_domains(conn, _) do
    conn
        |> put_status(400)
        |> put_view(DomainsCounterExWeb.ErrorView)
        |> render("400.json",
             %{message: "Params 'from', 'to' are not a numbers"})
  end
end
