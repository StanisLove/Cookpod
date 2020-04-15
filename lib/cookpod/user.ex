defmodule Cookpod.User do
  @moduledoc "App's user"

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :email])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end
end
