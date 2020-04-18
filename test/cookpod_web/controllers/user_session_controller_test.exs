defmodule CookpodWeb.UserSessionControllerTest do
  use CookpodWeb.ConnCase
  use CookpodWeb.BasicAuthCase
  import Plug.Test

  describe "GET #new" do
    test "be success", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth()
        |> get("/signin")

      assert html_response(conn, 200) =~ "Sign in"
    end

    test "redirects to root when signed in", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth()
        |> init_test_session(current_user: %{login: "login"})
        |> get("/signin")

      assert redirected_to(conn, 302) =~ "/"
    end
  end

  describe "POST #create" do
    def post_form(conn, password) do
      conn
      |> using_basic_auth()
      |> post("/user_sessions", %{"user" => %{login: "login", password: password}})
    end

    test "redirects to signin with invalid password", %{conn: conn} do
      conn = post_form(conn, 'invalid')
      assert redirected_to(conn, 302) =~ "/signin"
    end

    test "redirects to root with valid credentials", %{conn: conn} do
      conn = post_form(conn, 'qwerty')
      assert redirected_to(conn, 302) =~ "/"
    end

    test "redirects to root when ActionClauseError", %{conn: conn} do
      assert_error_sent 302, fn ->
        conn
        |> using_basic_auth()
        |> post("/user_sessions", %{})

        assert redirected_to(conn, 302) =~ "/"
      end
    end
  end

  describe "DELETE #delete" do
    test "redirects to root", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth()
        |> init_test_session(current_user: %{login: "login"})
        |> delete("/signout")

      assert redirected_to(conn, 302) =~ "/"
    end
  end
end
