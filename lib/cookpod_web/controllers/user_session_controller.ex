defmodule CookpodWeb.UserSessionController do
  use CookpodWeb, :controller

  alias Cookpod.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        render(conn, :new)

      _ ->
        conn
        |> put_flash(:error, gettext("Already signed in"))
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"user" => %{"login" => login, "password" => password}}) do
    case authenticate(login, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome back!"))
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      _ ->
        conn
        |> put_flash(:error, gettext("Bad email/password combination"))
        |> redirect(to: Routes.user_session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, gettext("Good bye!"))
    |> redirect(to: "/")
  end

  defp authenticate(login, password) do
    case User.get_by_login_and_pass(login, password) do
      nil -> {:error, :unauthorized}
      user -> {:ok, user}
    end
  end
end
