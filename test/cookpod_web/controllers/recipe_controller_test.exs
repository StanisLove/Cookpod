defmodule CookpodWeb.RecipeControllerTest do
  use CookpodWeb.ConnCase
  alias Cookpod.Recipes

  @moduletag :auth

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{name: nil}
  @upload %Plug.Upload{path: "test/fixtures/elixir.jpeg", filename: "elixir.jpeg"}

  defp create_recipe(_) do
    {:ok, recipe: insert(:recipe, @create_attrs)}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :new))
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    def post_recipe(conn, attrs) do
      post(conn, Routes.recipe_path(conn, :create), recipe: attrs)
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post_recipe(conn, @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.recipe_path(conn, :show, id)

      conn = get(conn, Routes.recipe_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Recipe"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post_recipe(conn, @invalid_attrs)
      assert html_response(conn, 200) =~ "New Recipe"
    end

    test "upload image", %{conn: conn} do
      conn = post_recipe(conn, Map.merge(@create_attrs, %{icon: @upload}))
      %{id: id} = redirected_params(conn)
      recipe = Recipes.get_recipe!(id)
      thumb = Cookpod.Icon.local_path({recipe.icon, recipe}, :thumb)
      medium = Cookpod.Icon.local_path({recipe.icon, recipe}, :medium)

      assert File.exists?(thumb) && File.exists?(medium)
    end
  end

  describe "edit recipe" do
    setup [:create_recipe]

    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn = get(conn, Routes.recipe_path(conn, :edit, recipe))
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @update_attrs)
      assert redirected_to(conn) == Routes.recipe_path(conn, :show, recipe)

      conn = get(conn, Routes.recipe_path(conn, :show, recipe))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Recipe"
    end

    test "upload image", %{conn: conn, recipe: recipe} do
      assert is_nil(recipe.icon)

      put(conn, Routes.recipe_path(conn, :update, recipe), recipe: %{icon: @upload})
      # reload
      recipe = Recipes.get_recipe!(recipe.id)
      thumb = Cookpod.Icon.local_path({recipe.icon, recipe}, :thumb)
      medium = Cookpod.Icon.local_path({recipe.icon, recipe}, :medium)

      assert File.exists?(thumb) && File.exists?(medium)
    end
  end

  describe "delete recipe" do
    test "deletes chosen recipe", %{conn: conn} do
      recipe = insert(:recipe)
      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))
      assert redirected_to(conn) == Routes.recipe_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_path(conn, :show, recipe))
      end
    end

    test "deletes uploaded files", %{conn: conn} do
      attrs = Map.merge(@create_attrs, %{icon: @upload})
      {:ok, recipe} = Recipes.create_recipe(attrs)
      thumb = Cookpod.Icon.local_path({recipe.icon, recipe}, :thumb)
      medium = Cookpod.Icon.local_path({recipe.icon, recipe}, :medium)

      assert File.exists?(thumb) && File.exists?(medium)

      delete(conn, Routes.recipe_path(conn, :delete, recipe))

      refute File.exists?(thumb) || File.exists?(medium)
    end
  end
end
