defmodule Wo.Web.Router do
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

  # scope "/", Wo.Web do
  #   pipe_through :browser # Use the default browser stack
  #
  #   get "/", PageController, :index
  #   get "/newsletter", PageController, :newsletter
  #   get "/series", PageController, :series_index
  #   get "/series/:slug", PageRouter, :sermon_index, as: :page
  #   get "/sermon/:slug", PageRouter, :sermon_show, as: :page
  #
  #   get "/search", SearchController, :index
  #
  #   resources "/sermon_series", SermonSeriesController, except: [:show] do
  #     resources "/sermon", SermonController
  #   end
  # end

  scope "/admin", Wo.Web do
    pipe_through :browser

    get "/", Wo.Web.ContentEditor.SermonSeriesController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wo do
  #   pipe_through :api
  # end
end
