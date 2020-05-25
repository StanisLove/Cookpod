defmodule CookpodWeb.Integration.SignUpTest do
  use CookpodWeb.IntegrationCase, async: true
  use Cookpod.Mocks.EmailKit

  alias Cookpod.{Repo, User}

  setup do
    {:ok, user: build(:user)}
  end

  test "it signs up user", %{conn: conn, user: user} do
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
      assigns: %{current_user: Repo.get_by(User, email: user.email)}
    )
  end

  test "it doesn't sign up user without password confirmation", %{conn: conn, user: user} do
    get(conn, "/")
    |> follow_link("/signin")
    |> follow_link("/signup")
    |> follow_form(%{
      user: %{
        email: user.email,
        password: user.password
      }
    })
    |> assert_response(
      status: 200,
      path: "/users"
    )

    # TODO: uncomment next line when https://github.com/boydm/phoenix_integration/pull/43 be merged
    # |> refute_response(assigns: %{current_user: Repo.get_by(User, email: user.email)})
  end
end
