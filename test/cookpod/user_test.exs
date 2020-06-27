defmodule Cookpod.UserTest do
  use Cookpod.DataCase

  import Mox

  alias Cookpod.User
  alias Ecto.Changeset

  @valid_attrs %{email: "test@exampl.com", name: "Valdimir", surname: "Lenin"}
  @reg_attrs Map.merge(@valid_attrs, %{password: "qwerty", password_confirmation: "qwerty"})

  setup do
    stub(EmailKitMock, :available?, fn _ -> true end)
    :ok
  end

  describe "#changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "without any name" do
      changeset = User.changeset(%User{}, Map.drop(@valid_attrs, [:name, :surname]))
      assert changeset.valid?
    end

    test "without email" do
      changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :email))
      refute changeset.valid?
    end

    test "with empty email" do
      changeset = User.changeset(%User{}, %{@valid_attrs | email: ""})
      refute changeset.valid?
    end

    test "with uppercase email" do
      changeset = User.changeset(%User{}, %{@valid_attrs | email: "TEST@EXAMPLE.COM"})
      assert changeset.valid?
      assert Changeset.get_field(changeset, :email) == "test@example.com"
    end

    test "with is not available email" do
      EmailKitMock |> expect(:available?, fn _ -> false end)
      changeset = User.changeset(%User{}, @valid_attrs)
      refute changeset.valid?
    end
  end

  describe "#registration_changeset" do
    test "with password and confirmation" do
      changeset = User.registration_changeset(%User{}, @reg_attrs)
      assert changeset.valid?
      refute is_nil(Changeset.get_field(changeset, :password_hash))
    end

    test "without password and confirmation" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      refute changeset.valid?
    end

    test "without password" do
      changeset = User.registration_changeset(%User{}, Map.delete(@reg_attrs, :password))
      refute changeset.valid?
    end

    test "without password_confirmation" do
      changeset =
        User.registration_changeset(%User{}, Map.delete(@reg_attrs, :password_confirmation))

      refute changeset.valid?
    end

    test "with short password" do
      changeset =
        User.registration_changeset(
          %User{},
          Map.merge(@reg_attrs, %{password: "qwert", password_confirmation: "qwert"})
        )

      refute changeset.valid?
    end

    test "with not equal confirmation" do
      changeset =
        User.registration_changeset(
          %User{},
          Map.merge(@reg_attrs, %{password: "qwerty", password_confirmation: "123456"})
        )

      refute changeset.valid?
    end
  end
end
