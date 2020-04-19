defmodule CookpodWeb.Plugs.AuthPlug do
  @moduledoc """
  Redirect not authenticated users to signin path
  """

  import Plug.Conn
  import Phoenix.Controller
  import CookpodWeb.Gettext

  alias Cookpod.Repo
  alias Cookpod.User
  alias CookpodWeb.Router.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    auth_from_session(conn, get_session(conn, :user_id))
  end

  defp auth_from_session(conn, nil), do: redirect_to_sign_in(conn)

  defp auth_from_session(conn, user_id) do
    user = Repo.get(User, user_id)
    auth_user(conn, user)
  end

  defp auth_user(conn, nil) do
    conn
    |> delete_session(:user_id)
    |> redirect_to_sign_in
  end

  defp auth_user(conn, user), do: assign(conn, :current_user, user)

  defp redirect_to_sign_in(conn) do
    conn
    |> put_flash(:error, gettext("You need to sign in before continuing."))
    |> redirect(to: Helpers.user_session_path(conn, :new))
    |> halt()
  end
end
