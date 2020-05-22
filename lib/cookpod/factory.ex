defmodule Cookpod.Factory do
  @moduledoc """
  Factories powered by ex_machina
  """
  use ExMachina.Ecto, repo: Cookpod.Repo

  alias Cookpod.Recipes.Recipe
  alias Cookpod.User

  def user_factory do
    %User{
      name: "Jane",
      surname: "Smith",
      email: sequence(:email, &"email-#{&1}@exampl.com")
    }
  end

  def set_password(user, password) do
    user
    |> User.registration_changeset(%{"password" => password, "password_confirmation" => password})
    |> Ecto.Changeset.apply_changes()
  end

  def recipe_factory do
    %Recipe{
      name: "Recipe",
      description: "Desc"
    }
  end
end
