defmodule Cookpod.RecipesTest do
  use Cookpod.DataCase

  alias Cookpod.Recipes

  describe "recipes" do
    alias Cookpod.Recipes.Recipe

    @upload %Plug.Upload{path: "test/fixtures/elixir.jpeg", filename: "elixir.jpeg"}
    @valid_attrs %{description: "some description", name: "some name", icon: @upload}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      icon: @upload
    }
    @invalid_attrs %{name: nil}

    test "list_recipes/0 returns all recipes" do
      recipe = insert(:recipe)
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = insert(:recipe)
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@valid_attrs)
      assert recipe.description == "some description"
      assert recipe.icon.file_name == "elixir.jpeg"
      assert recipe.name == "some name"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert recipe.description == "some updated description"
      assert recipe.icon.file_name == "elixir.jpeg"
      assert recipe.name == "some updated name"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = insert(:recipe)
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = insert(:recipe)
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end

    test "publish_recipe/1 with draft recipe" do
      recipe = insert(:recipe)
      assert recipe.status == :draft
      assert {:ok, %Recipe{} = recipe} = Recipes.publish_recipe(recipe)
      assert recipe.status == :published
    end

    test "publish_recipe/1 with archived recipe" do
      recipe = insert(:recipe, status: :archived)
      assert recipe.status == :archived
      assert {:error, %Ecto.Changeset{}} = Recipes.publish_recipe(recipe)
    end
  end
end
