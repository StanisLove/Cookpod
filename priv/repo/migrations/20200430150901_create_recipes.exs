defmodule Cookpod.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :description, :text
      add :icon, :string

      timestamps()
    end
  end
end
