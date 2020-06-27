defmodule CookpodWeb.RecipeLive.Form do
  @moduledoc false

  use Phoenix.LiveView
  alias Cookpod.Recipes
  alias Cookpod.Recipes.Recipe
  alias CookpodWeb.RecipeView

  def mount(_params, %{"action" => action, "csrf_token" => csrf_token}, socket) do
    assigns = %{
      conn: socket,
      action: action,
      csrf_token: csrf_token,
      changeset: Recipes.change_recipe(%Recipe{})
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    RecipeView.render("form.html", assigns)
  end

  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      %Recipe{}
      |> Recipe.create_changeset(recipe_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
