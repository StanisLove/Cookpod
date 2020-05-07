defmodule Cookpod.Recipes.Recipe do
  @moduledoc "Recipe schema"

  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :description, :string
    field :icon, Cookpod.Icon.Type
    field :name, :string

    timestamps()
  end

  def create_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end

  def update_changeset(recipe, attrs) do
    recipe
    |> create_changeset(attrs)
    |> cast_attachments(attrs, [:icon])
  end
end
