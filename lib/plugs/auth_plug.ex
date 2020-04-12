defmodule CookpodWeb.Plugs.AuthPlug do
  @moduledoc """
  Redirect not authenticated users to signin path
  """

  import Plug.Conn
  import Phoenix.Controller
  import CookpodWeb.Gettext

  alias CookpodWeb.Router.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> put_flash(:error, gettext("You need to sign in before continuing."))
        |> redirect(to: Helpers.user_session_path(conn, :new))
        |> halt()

      _ ->
        conn
    end
  end
end
