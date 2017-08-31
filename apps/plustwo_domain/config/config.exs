use Mix.Config

config :plustwo_domain, ecto_repos: [Plustwo.Domain.Repo]

import_config "#{Mix.env}.exs"
