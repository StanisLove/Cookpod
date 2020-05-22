defmodule Cookpod.Recipes.Recipe do
  @moduledoc "Recipe schema"

  use Ecto.Schema
  use Waffle.Ecto.Schema
  import CookpodWeb.Gettext
  import Ecto.Changeset
  alias Cookpod.Recipes.StatusFsm

  schema "recipes" do
    field :description, :string
    field :icon, Cookpod.Icon.Type
    field :name, :string
    field :status, RecipeSatusEnum, default: StatusFsm.new().state

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

  def publish_changeset(recipe) do
    new_status = StatusFsm.new(state: recipe.status) |> StatusFsm.publish() |> Map.get(:state)

    if new_status == StatusFsm.error_state() do
      recipe
      |> change
      |> add_error(:status, gettext("The recipe can't be published"))
    else
      recipe
      |> change(status: new_status)
    end
  end
end
