defmodule Cookpod.User do
  @moduledoc "App's user"

  use Ecto.Schema
  import Ecto.Changeset
  import CookpodWeb.Gettext
  import Bcrypt, only: [hash_pwd_salt: 1, verify_pass: 2]

  alias __MODULE__
  alias Cookpod.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    field :surname, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def get_by_login_and_pass(login, password) do
    case Repo.get_by(User, email: login) do
      nil ->
        nil

      user ->
        if verify_pass(password, user.password_hash), do: user, else: nil
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :email])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: gettext("doesn't match"))
    |> put_pass_hash
  end

  def new_changeset, do: changeset(%User{}, %{})

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
