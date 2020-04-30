defmodule Cookpod.Repo do
  use Ecto.Repo, otp_app: :cookpod, adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  def count(query) do
    one(Ecto.Query.from(r in query, select: count(r.id)))
  end
end
