defmodule CookpodWeb.Router do
  use CookpodWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CookpodWeb.Plugs.SetLocale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/terms", PageController, :terms

    get "/signin", UserSessionController, :new
    delete "/signout", UserSessionController, :delete
    resources "/user_sessions", UserSessionController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end
end
