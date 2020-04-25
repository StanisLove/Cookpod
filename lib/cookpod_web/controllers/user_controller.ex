defmodule CookpodWeb.UserController do
  use CookpodWeb, :controller

  alias Cookpod.Repo
  alias Cookpod.User

  def new(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        render(conn, :new, changeset: User.new_changeset())

      _ ->
        conn
        |> put_flash(:error, gettext("Already signed in"))
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome aboard!"))
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
