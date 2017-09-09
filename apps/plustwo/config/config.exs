use Mix.Config

config :plustwo,
  namespace: Plustwo,
  ecto_repos: [Plustwo.Infrastructure.Repo.Postgres],
  redis_host: System.get_env("REDIS_HOST"),
  redis_port: System.get_env("REDIS_PORT")

config :plustwo, Plustwo.Application.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1EGLdnTuSycKYvw8bVfyiUMrAFqyl7Kp3i1PsSDzNnXc2N6lalWzGIGjx9Ts+DlU",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Plustwo.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Plustwo.Infrastructure.Repo.Postgres

config :vex,
  sources: [
    Plustwo.Infrastructure.Validation.Validators,
    Vex.Validators,
  ]

config :plustwo, Plustwo.Infrastructure.Services.Mailer,
  adapter: Bamboo.LocalAdapter

config :stripity_stripe,
  secret_key: System.get_env("STRIPE_SECRET_KEY")

config :ex_twilio,
  account_sid: {:system, "TWILIO_ACCOUNT_SID"},
  auth_token: {:system, "TWILIO_AUTH_TOKEN"}

config :recaptcha,
  public_key: {:system, "RECAPTCHA_PUBLIC_KEY"},
  secret: {:system, "RECAPTCHA_PRIVATE_KEY"}

import_config "#{Mix.env}.exs"
