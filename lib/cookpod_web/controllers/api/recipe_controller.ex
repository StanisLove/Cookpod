defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller
  use PhoenixSwagger

  alias Cookpod.Recipes

  def swagger_definitions do
    %{
      Recipe:
        swagger_schema do
          title("Recipe")
          description("Published recipe")

          properties do
            id(:integer, "Recipe ID", required: true, example: 1)
            name(:string, "Recipe name", required: true, example: "name")
            description(:string, "Recipe description", example: "Desc")
            icon(:string, "Icon url", format: :url, example: "https://icons.com/icon2.png")
          end
        end,
      RecipesResponse:
        swagger_schema do
          property(:data, Schema.array(:Recipe), "Array of recipes")
        end,
      RecipeResponse:
        swagger_schema do
          property(:data, Schema.ref(:Recipe), "One recipe")
        end
    }
  end

  swagger_path(:index) do
    get("/recipes")
    summary("List recipes")
    produces("application/json")
    response(200, "OK", Schema.ref(:RecipesResponse))
  end

  def index(conn, _params) do
    render(conn, "index.json", recipes: Recipes.list_recipes())
  end

  swagger_path(:show) do
    get("/recipes/{id}")
    summary("One recipe")
    produces("application/json")
    parameter(:id, :path, :integer, "Recipe ID", required: true, example: 1)
    response(200, "OK", Schema.ref(:RecipeResponse))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", recipe: Recipes.get_recipe!(id))
  end
end
