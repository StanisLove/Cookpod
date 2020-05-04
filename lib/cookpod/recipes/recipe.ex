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

  def icon_path(%{icon: nil}), do: nil

  def icon_path(%{icon: icon}) do
    "http://localhost:9000/cookpod/#{icon}"
  end
end
