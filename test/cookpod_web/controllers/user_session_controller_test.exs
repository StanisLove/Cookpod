defmodule CookpodWeb.UserSessionControllerTest do
  use CookpodWeb.ConnCase

  describe "GET #new" do
    test "be success", %{conn: conn} do
      assert conn |> get("/signin") |> html_response(200) =~ "Sign in"
    end

    test "redirects to root when signed in", %{conn: conn} do
      conn =
        conn
        |> init_test_session(user_id: insert(:user).id)
        |> get("/signin")

      assert redirected_to(conn, 302) == "/"
    end
  end

  describe "POST #create" do
    def post_form(conn, login, password) do
      conn
      |> post("/user_sessions", %{"user" => %{login: login, password: password}})
    end

    test "redirects to signin with invalid password", %{conn: conn} do
      user = insert(:user)
      conn = post_form(conn, user.email, "invalid")
      assert redirected_to(conn, 302) == "/signin"
    end

    test "redirects to root with valid credentials", %{conn: conn} do
      user = insert(:user)
      conn = post_form(conn, user.email, "qwerty")
      assert redirected_to(conn, 302) == "/"
    end

    test "redirects to root when ActionClauseError", %{conn: conn} do
      assert_error_sent 302, fn ->
        conn |> post("/user_sessions", %{})
        assert redirected_to(conn, 302) == "/"
      end
    end
  end

  describe "DELETE #delete" do
    test "redirects to root", %{conn: conn} do
      assert conn |> delete("/signout") |> redirected_to(302) == "/"
    end
  end
end
