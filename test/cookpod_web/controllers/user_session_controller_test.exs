defmodule CookpodWeb.UserSessionControllerTest do
  use CookpodWeb.ConnCase

  describe "GET #new" do
    test "be success", %{conn: conn} do
      conn = get(conn, "/signin")
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "POST #create" do
    def post_form(conn, password) do
      post(conn, "/user_sessions", %{"user" => %{login: "login", password: password}})
    end

    test "redirects to signin with invalid password", %{conn: conn} do
      conn = post_form(conn, 'invalid')
      assert redirected_to(conn, 302) =~ "/signin"
    end

    test "redirects to root with valid credentials", %{conn: conn} do
      conn = post_form(conn, 'qwerty')
      assert html_response(conn, 302) =~ "/"
    end
  end

  describe "DELETE #delete" do
    test "redirects to root", %{conn: conn} do
      conn = delete(conn, "/signout")
      assert html_response(conn, 302) =~ "/"
    end
  end
end
