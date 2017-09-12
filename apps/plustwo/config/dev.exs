use Mix.Config

config :plustwo, Plustwo.Application.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :plustwo, Plustwo.Infrastructure.Repo.Postgres,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plustwo_dev",
  hostname: "localhost",
  pool_size: 10

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  database: "plustwo_event_store_dev",
  pool_size: 10
