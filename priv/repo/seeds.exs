# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Cookpod.Factory, only: [set_password: 2]

alias Cookpod.Repo
alias Cookpod.User

users_data = [
  %{email: "jack@cookpod.com", name: "Jack", surname: "Daniels"},
  %{email: "john@cookpod.com", name: "Johnnie", surname: "Walker"}
]

Enum.each(users_data, fn data ->
  User.new_changeset()
  |> User.changeset(data)
  |> set_password("qwerty")
  |> Repo.insert!()
end)
