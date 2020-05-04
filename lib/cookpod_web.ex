defmodule CookpodWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use CookpodWeb, :controller
      use CookpodWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: CookpodWeb

      import Plug.Conn
      import CookpodWeb.Gettext
      alias CookpodWeb.Router.Helpers, as: Routes

      def current_user(conn) do
        conn.assigns[:current_user]
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/cookpod_web/templates",
        namespace: CookpodWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import CookpodWeb.ErrorHelpers
      import CookpodWeb.Gettext
      alias CookpodWeb.Router.Helpers, as: Routes

      def current_user(conn) do
        conn.assigns[:current_user]
      end

      def image(conn, nil) do
        img_tag(Routes.static_path(conn, "/images/no_image.png"), alt: "No image")
      end

      def image(_conn, img_path), do: img_tag(img_path)
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import CookpodWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
