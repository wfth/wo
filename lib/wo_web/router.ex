defmodule WoWeb.Router do
  use WoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WoWeb.Plug.RenewSession
  end

  pipeline :authorized do
    plug WoWeb.Plug.Authorize
  end

  scope "/", WoWeb.Visitor do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    get "/series", SermonSeriesController, :index
    get "/series/:slug", SermonSeriesController, :show

    get "/sermon/:slug", SermonController, :show

    get "/search", SearchController, :index

    get "/newsletter", NewsletterController, :signup

    get "/register", VisitorController, :new
    post "/register", VisitorController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/admin", WoWeb.Admin, as: :admin do
    pipe_through :browser

    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/admin", WoWeb.Admin, as: :admin do
    pipe_through [:browser, :authorized]

    get "/", SermonSeriesController, :index
    delete "/logout", SessionController, :delete

    resources "/sermon_series", SermonSeriesController, except: [:show] do
      resources "/sermon", SermonController
    end
  end
end
