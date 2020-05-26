defmodule CookpodWeb.Integration.SignInTest do
  use CookpodWeb.IntegrationCase, async: true

  alias Cookpod.{Repo, User}

  setup do
    {:ok, user: Cookpod.Repo.get!(User, insert(:user).id)}
  end

  test "it signs in user", %{conn: conn, user: user} do
    get(conn, "/")
    |> follow_link("/signin")
    |> follow_form(%{
      user: %{
        login: user.email,
        password: "qwerty"
      }
    })
    |> assert_response(
      status: 200,
      path: "/",
      assigns: %{current_user: user}
    )
  end

  test "it doesn't sign in user with bad credentials", %{conn: conn, user: user} do
    get(conn, "/")
    |> follow_link("/signin")
    |> follow_form(%{
      user: %{
        login: user.email,
        password: "bad_pass"
      }
    })
    |> assert_response(status: 200, path: "/signin")

    # TODO: uncomment next line when https://github.com/boydm/phoenix_integration/pull/43 be merged
    # |> refute_response(assigns: %{current_user: user})
  end
end
