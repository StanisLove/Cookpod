# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookpod,
  ecto_repos: [Cookpod.Repo]

# Configures the endpoint
config :cookpod, CookpodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tNM6mITr/7+wKzchBsOAmg0WanLTlb2M2t8ilYuZWupn2Jbpx9e+4veKgomTHiSG",
  render_errors: [view: CookpodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookpod.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ZSXyAgxp"]

config :cookpod, CookpodWeb.Gettext, default_locale: "ru", locales: ~w(en ru)

config :cookpod,
  basic_auth: [
    username: "admin",
    password: "qwerty",
    realm: "Admin Area"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :ex_aws,
  access_key_id: "minio_access_key",
  secret_access_key: "minio_secret_key",
  json_codec: Jason,
  debug_requests: true

config :ex_aws, :s3,
  scheme: "http://",
  host: "localhost",
  port: 9000

config :waffle,
  storage: Waffle.Storage.S3,
  bucket: "cookpod",
  asset_host: "http://localhost:9000/cookpod"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
