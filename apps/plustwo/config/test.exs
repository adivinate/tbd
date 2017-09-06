use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plustwo, Plustwo.Application.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_unit,
  capture_log: true

# Configure your database
config :plustwo, Plustwo.Infrastructure.Repo.Postgres,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plustwo_test",
  hostname: "localhost",
  pool_size: 1

# Configure Postgres database for events
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "plustwo_event_store_test",
  hostname: "localhost",
  pool_size: 1

# Configure Redis
config :redis,
  host: "localhost",
  port: 6379

config :bcrypt_elixir, :log_rounds, 4
