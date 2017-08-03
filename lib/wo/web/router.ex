defmodule Wo.Web.Router do
  use Wo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Wo.Web.Visitor do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    get "/series", SermonSeriesController, :index
    get "/series/:slug", SermonSeriesController, :show

    get "/sermon/:slug", SermonController, :show

    get "/search", SearchController, :index
  end

  scope "/admin", Wo.Web.Admin, as: :admin do
    pipe_through :browser

    get "/", SermonSeriesController, :index

    resources "/sermon_series", SermonSeriesController, except: [:show] do
      resources "/sermon", SermonController
    end
  end
end
