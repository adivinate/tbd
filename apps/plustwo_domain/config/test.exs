use Mix.Config

# Configure your database
config :plustwo_domain, Plustwo.Domain.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plustwo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
