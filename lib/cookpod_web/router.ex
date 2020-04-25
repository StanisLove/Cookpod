defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

  import CookpodWeb.Gettext

  pipeline :browser do
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
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

    get "/signup", UserController, :new
    resources "/users", UserController, only: [:create]
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    conn
    |> put_status(302)
    |> fetch_session()
    |> fetch_flash()
    |> put_flash(:error, gettext("Bad request"))
    |> redirect(to: "/")
  end

  # TODO: Send error to Sentry
  def handle_errors(conn, _), do: conn

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end
end
