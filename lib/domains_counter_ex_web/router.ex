defmodule DomainsCounterExWeb.Router do
  use DomainsCounterExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DomainsCounterExWeb do
    pipe_through :api

    get "/visited_domains", DomainController, :show_domains
    post "/visited_links", DomainController, :save_links
  end
end
