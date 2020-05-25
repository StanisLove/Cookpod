defmodule CookpodWeb.Integration.SignUpTest do
  use CookpodWeb.IntegrationCase, async: true
  use Cookpod.Mocks.EmailKit

  alias Cookpod.{Repo, User}

  test "it is signs up user", %{conn: conn} do
    user = build(:user)

    get(conn, "/")
    |> follow_link("/signin")
    |> follow_link("/signup")
    |> follow_form(%{
      user: %{
        email: user.email,
        password: user.password,
        password_confirmation: user.password
      }
    })
    |> assert_response(
      status: 200,
      path: "/",
      assigns: [{:current_user, Repo.get_by(User, email: user.email)}]
    )
  end
end
