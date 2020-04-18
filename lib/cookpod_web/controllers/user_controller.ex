defmodule CookpodWeb.UserController do
  use CookpodWeb, :controller

  alias Cookpod.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render(conn, :new, changeset: User.new_changeset())
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_flash(:info, gettext("Welcome aboard!"))
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
