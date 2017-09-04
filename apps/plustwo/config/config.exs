# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :plustwo,
  namespace: Plustwo,
  ecto_repos: [Plustwo.Infrastructure.Repo.Postgres]

# Configures the endpoint
config :plustwo, Plustwo.Application.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1EGLdnTuSycKYvw8bVfyiUMrAFqyl7Kp3i1PsSDzNnXc2N6lalWzGIGjx9Ts+DlU",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Plustwo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures CQRS / ES Commanded
config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

# Configures ES Projections
config :commanded_ecto_projections,
  repo: Plustwo.Infrastructure.Repo.Postgres

# Configures validators
config :vex,
  sources: [
    Plustwo.Infrastructure.Validation.Validators,
    Vex.Validators,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
