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
    result = RedisDB.save_domains(domains)
    Logger.debug("save_links: #{inspect(result)}")

    render(conn, "save_links.json", result: %{"result" => "ok"})
  end

  def save_links(conn, params) do
    conn
    |> put_status(400)
    |> put_view(DomainsCounterExWeb.ErrorView)
    |> render(
      "400.json",
      %{message: "#{inspect(params)} - is not a list"}
    )
  end

  def show_domains(conn, %{"from" => from, "to" => to}) do
    with {parsed_from, ""} <- Float.parse(from),
         {parsed_to, ""} <- Float.parse(to) do
      domains = RedisDB.get_domains(parsed_from, parsed_to)

      render(
        conn,
        "show_domains.json",
        result: %{"domains" => domains, "status" => "ok"}
      )
    else
      :error ->
        show_domains_error(conn, "Params 'from' or 'to' are not a number")
    end
  end

  def show_domains(conn, _) do
    show_domains_error(conn, "Params 'from', 'to' are not a numbers")
  end

  defp show_domains_error(conn, msg) do
    conn
    |> put_status(400)
    |> put_view(DomainsCounterExWeb.ErrorView)
    |> render("400.json", %{message: msg})
  end
end
