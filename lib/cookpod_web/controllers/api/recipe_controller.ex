defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller

  alias Cookpod.Recipes

  def index(conn, _params) do
    render(conn, "index.json", recipes: Recipes.list_recipes())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", recipe: Recipes.get_recipe!(id))
  end
end
