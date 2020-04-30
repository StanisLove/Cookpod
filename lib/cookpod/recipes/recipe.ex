defmodule Cookpod.Recipes.Recipe do
  @moduledoc "Recipe schema"

  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :description, :string
    field :icon, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
  end
end
