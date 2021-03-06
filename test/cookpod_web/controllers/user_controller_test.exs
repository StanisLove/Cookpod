defmodule CookpodWeb.UserControllerTest do
  use CookpodWeb.ConnCase

  import Mox

  alias Cookpod.User

  setup do
    stub(EmailKitMock, :available?, fn _ -> true end)
    :ok
  end

  describe "GET #new" do
    test "be success", %{conn: conn} do
      assert conn |> get("/signup") |> html_response(200) =~ "Sign up"
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
    test "redirects to root after registration", %{conn: conn} do
      params = params_for(:user) |> Map.take([:email, :password, :password_confirmation])

      assert from(user in User, where: user.email == ^params[:email]) |> count == 0
      assert conn |> post("/users", %{"user" => params}) |> redirected_to(302) == "/"
      assert from(user in User, where: user.email == ^params[:email]) |> count == 1
    end
  end
end
