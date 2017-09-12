use Mix.Config

config :plustwo, Plustwo.Application.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :ex_unit,
  capture_log: true

config :plustwo, Plustwo.Infrastructure.Mailer,
  adapter: Bamboo.TestAdapter

config :plustwo, Plustwo.Infrastructure.Repo.Postgres,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plustwo_test",
  hostname: "localhost",
  pool_size: 1

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  database: "plustwo_event_store_test",
  pool_size: 1

config :bcrypt_elixir, :log_rounds, 4
