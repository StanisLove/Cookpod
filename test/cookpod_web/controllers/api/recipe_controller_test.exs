defmodule CookpodWeb.Controllers.Api.RecipeControllerTest do
  use CookpodWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  describe "index" do
    test "show chosen recipes", %{conn: conn, swagger_schema: schema} do
      insert_pair(:recipe)
      conn = conn |> get(Routes.api_recipe_path(conn, :index))

      validate_resp_schema(conn, schema, "RecipesResponse")
      assert json_response(conn, 200)["data"] |> length == 2
    end
  end

  describe "show" do
    test "show chosen recipe", %{conn: conn, swagger_schema: schema} do
      conn
      |> get(Routes.api_recipe_path(conn, :show, insert(:recipe)))
      |> validate_resp_schema(schema, "RecipeResponse")
      |> json_response(200)
    end
  end
end
