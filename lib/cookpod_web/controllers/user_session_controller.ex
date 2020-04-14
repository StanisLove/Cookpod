defmodule CookpodWeb.UserSessionController do
  use CookpodWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"login" => login, "password" => password}}) do
    case authenticate(login, password) do
      {:ok, login} ->
        conn
        |> put_flash(:info, gettext("Welcome back!"))
        |> put_session(:current_user, %{login: login})
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

  defp authenticate(login, "qwerty"), do: {:ok, login}
  defp authenticate(_, _), do: {:error, :unauthorized}
end
