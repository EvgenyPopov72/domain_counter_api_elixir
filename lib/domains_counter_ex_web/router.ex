defmodule DomainsCounterExWeb.Router do
  use DomainsCounterExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DomainsCounterExWeb do
    pipe_through :api
  end
end
