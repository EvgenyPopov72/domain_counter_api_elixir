defmodule DomainsCounterExWeb.DomainView do
  use DomainsCounterExWeb, :view

  def render("show_domains.json", %{result: result}) do
    result
  end

  def render("save_links.json", %{result: result}) do
    result
  end
end
