defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  describe "GET #index" do
    test "be success", %{conn: conn} do
      assert conn |> get("/") |> html_response(200) =~ "Phoenix!"
    end
  end

  describe "GET #terms" do
    test "redirects unauthorized user", %{conn: conn} do
      assert conn |> get("/terms") |> redirected_to(302) == "/signin"
    end

    test "be success for authorized user", %{conn: conn} do
      conn =
        conn
        |> init_test_session(user_id: insert(:user).id)
        |> get("/terms")

      assert html_response(conn, 200)
    end
  end

  describe "GET #not_existed_route" do
    test "responds with 404 page", %{conn: conn} do
      response =
        assert_error_sent :not_found, fn ->
          conn
          |> get("/not_existed_route")
        end

      assert {404, [_h | _t], html} = response
      assert html =~ "Page not found"
    end
  end
end
