defmodule Cookpod.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias Cookpod.Repo

  alias Cookpod.Recipes.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs) do
    %Recipe{}
    |> Recipe.create_changeset(attrs)
    |> Repo.insert()
    |> add_icon(attrs["icon"] || attrs[:icon])
  end

  def add_icon(result, nil), do: result

  def add_icon({:error, changeset}, _), do: {:error, changeset}

  def add_icon({:ok, recipe}, icon), do: update_recipe(recipe, %{icon: icon})

  # def create_recipe(%{icon: %Plug.Upload{}} = attrs), do: create_recipe(attrs)

  # def create_recipe(%{"icon" => %Plug.Upload{}} = attrs) do
  #   {icon, rest} = Map.split(attrs, ["icon"])

  #   create_recipe(rest) |> add_icon(icon)
  # end

  # def create_recipe(attrs) do
  #   %Recipe{}
  #   |> Recipe.create_changeset(attrs)
  #   |> Repo.insert()
  # end

  # def add_icon({:ok, recipe}, icon), do: update_recipe(recipe, icon)

  # def add_icon(error, _), do: error

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe) |> flush_icons
  end

  def flush_icons({:ok, %Recipe{icon: nil} = recipe}), do: {:ok, recipe}

  def flush_icons({:ok, recipe}) do
    Cookpod.Icon.delete({recipe.icon, recipe})
    {:ok, recipe}
  end

  def flush_icons(error, _), do: error

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.create_changeset(recipe, %{})
  end

  @doc """
  Publish recipe.

  ## Examples

    iex> pbulish_recipe(recipe)
    {:ok, %Recipe{}}

    iex> publish_recipe(recipe)
    {:error, %Ecto.Changeset{}}
  """
  def publish_recipe(%Recipe{} = recipe) do
    Recipe.publish_changeset(recipe) |> Repo.update()
  end
end
