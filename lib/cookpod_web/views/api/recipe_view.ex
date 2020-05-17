defmodule CookpodWeb.Api.RecipeView do
  use CookpodWeb, :view

  def render("index.json", %{recipes: recipes}) do
    %{data: render_many(recipes, __MODULE__, "recipe.json")}
  end

  def render("show.json", %{recipe: recipe}) do
    %{data: render_one(recipe, __MODULE__, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      icon: icon_url(:medium, recipe)
    }
  end
end
