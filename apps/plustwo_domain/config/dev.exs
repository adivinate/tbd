use Mix.Config

# Configure your database
config :plustwo_domain, Plustwo.Domain.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plustwo_dev",
  hostname: "localhost",
  pool_size: 10
