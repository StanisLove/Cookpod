defmodule CookpodWeb.UserController do
  use CookpodWeb, :controller

  alias Cookpod.Repo
  alias Cookpod.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render(conn, :new, changeset: User.new_changeset())
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Welcome aboard!"))
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
