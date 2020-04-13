defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  import Plug.Test

  describe "GET #index" do
    test "be success", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Phoenix!"
    end
  end

  describe "GET #terms" do
    test "redirects unauthorized user", %{conn: conn} do
      conn = get(conn, "/terms")
      assert redirected_to(conn, 302) =~ "/signin"
    end

    test "be success for authorized user", %{conn: conn} do
      conn =
        conn
        |> init_test_session(current_user: true)
        |> get("/terms")

      assert html_response(conn, 200)
    end
  end
end
