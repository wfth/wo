defmodule Wo.Router do
  use Wo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wo do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/search", SearchController, :index
    post "/search", SearchController, :search
    resources "/sermon_series", SermonSeriesController do
      resources "/sermon", SermonController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wo do
  #   pipe_through :api
  # end
end
