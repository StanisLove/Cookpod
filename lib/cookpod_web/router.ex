defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

  import CookpodWeb.Gettext

  pipeline :browser do
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CookpodWeb.Plugs.AuthPlug
    plug CookpodWeb.Plugs.SetLocale
  end

  pipeline :protected do
    plug :redirect_unauthorized
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/terms", PageController, :terms

    resources "/recipes", RecipeController do
      post "/publish", RecipeController, :publish, as: :publish
    end
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/signin", UserSessionController, :new
    delete "/signout", UserSessionController, :delete
    resources "/user_sessions", UserSessionController, only: [:create]

    get "/signup", UserController, :new
    resources "/users", UserController, only: [:create]
  end

  scope "/api/v1", CookpodWeb.Api, as: :api do
    pipe_through :api

    resources "/recipes", RecipeController, only: [:index, :show]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :cookpod, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Cookpod API"
      },
      basePath: "api/v1"
    }
  end

  def redirect_unauthorized(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, gettext("You need to sign in before continuing."))
      |> redirect(to: __MODULE__.Helpers.user_session_path(conn, :new))
      |> halt()
    end
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
end
