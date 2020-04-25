defmodule Cookpod.Factory do
  @moduledoc """
  Factories powered by ex_machina
  """
  use ExMachina.Ecto, repo: Cookpod.Repo

  alias Cookpod.User

  def user_factory do
    %User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@exampl.com")
    }
  end

  def set_password(user, password) do
    user
    |> User.registration_changeset(%{"password" => password, "password_confirmation" => password})
    |> Ecto.Changeset.apply_changes()
  end
end
