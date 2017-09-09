use Mix.Config

config :plustwo, Plustwo.Application.Endpoint,
  http: [port: {:system, "SERVER_PORT"}],
  url: [scheme: "https", host: "plustwo.io", port: 443],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :plustwo, Plustwo.Infrastructure.Repo.Postgres,
url: {:system, "READ_STORE_URL"},
  adapter: Ecto.Adapters.Postgres,
  pool_size: 20

config :eventstore, EventStore.Storage,
  url: {:system, "EVENT_STORE_URL"},
  serializer: Commanded.Serialization.JsonSerializer,
  pool_size: 20

config :plustwo, Plustwo.Infrastructure.Services.Mailer,
  adapter: Bamboo.PostmarkAdapter,
  api_key: System.get("POSTMARK_SERVER_TOKEN")
