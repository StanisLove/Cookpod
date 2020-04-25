defmodule CookpodWeb.UserControllerTest do
  use CookpodWeb.ConnCase

  describe "GET #new" do
    test "be success", %{conn: conn} do
      assert conn |> get("/signup") |> html_response(200) =~ "Sign up"
    end

    test "redirects to root when signed in", %{conn: conn} do
      conn =
        conn
        |> init_test_session(user_id: 1)
        |> get("/signin")

      assert redirected_to(conn, 302) == "/"
    end
  end

  describe "POST #create" do
    test "redirects to root after registration", %{conn: conn} do
      params =
        build(:user)
        |> set_password("qwerty")
        |> Map.take([:email, :password, :password_confirmation])

      assert conn |> post("/users", %{"user" => params}) |> redirected_to(302) == "/"
    end
  end
end
