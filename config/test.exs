use Mix.Config

# Configure your database
config :cookpod, Cookpod.Repo,
  username: "username",
  password: "password",
  database: "cookpod_test",
  hostname: "localhost",
  port: 6432,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cookpod, CookpodWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 4

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "tmp/test/files"

config :phoenix_integration,
  endpoint: CookpodWeb.Endpoint

config :cookpod, :email_kit, EmailKitMock
