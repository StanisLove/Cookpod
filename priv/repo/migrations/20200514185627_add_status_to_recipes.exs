defmodule Cookpod.Repo.Migrations.AddStatusToRecipes do
  use Ecto.Migration

  def change do
    RecipeSatusEnum.create_type()

    alter table(:recipes) do
      add :status, RecipeSatusEnum.type()
    end
  end
end
