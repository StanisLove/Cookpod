defmodule CookpodWeb.Plugs.AuthPlug do
  @moduledoc """
  Redirect not authenticated users to signin path
  """

  import Plug.Conn

  alias Cookpod.Repo
  alias Cookpod.User

  def init(opts), do: opts

  def call(conn, _opts) do
    auth_from_session(conn, get_session(conn, :user_id))
  end

  defp auth_from_session(conn, nil), do: conn

  defp auth_from_session(conn, user_id) do
    user = Repo.get(User, user_id)
    auth_user(conn, user)
  end

  defp auth_user(conn, nil) do
    conn |> delete_session(:user_id)
  end

  defp auth_user(conn, user), do: assign(conn, :current_user, user)
end
