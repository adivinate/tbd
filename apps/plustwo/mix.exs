defmodule Plustwo.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :plustwo,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
    ]
  end


  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Plustwo, []},
      extra_applications: [
        :absinthe,
        :absinthe_ecto,
        :absinthe_plug,
        :bamboo,
        :calendar,
        :comeonin,
        :eventstore,
        :ex_twilio,
        :httpoison,
        :logger,
        :phoenix_ecto,
        :phoenix_pubsub,
        :postgrex,
        :recaptcha,
        :runtime_tools,
        :stripity_stripe,
      ],
    ]
  end


  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end


  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, "~> 1.3.2"},
      {:absinthe_ecto, "~> 0.1.2"},
      {:absinthe_plug, "~> 1.3.1"},
      {:bamboo, "~> 0.8.0"},
      {:bamboo_postmark, "~> 0.4.1"},
      {:bcrypt_elixir, "~> 0.12.0"},
      {:calecto, "~> 0.16.2"},
      {:calendar, "~> 0.17.4"},
      {:comeonin, "~> 4.0.0"},
      {:commanded, "~> 0.13.0"},
      {:commanded_ecto_projections, "~> 0.4.0"},
      {:commanded_eventstore_adapter, "~> 0.1.0"},
      {:cowboy, "~> 1.1.2"},
      {:csv, "~> 2.0.0"},
      {:eventstore, "~> 0.9.0"},
      {:ex_twilio, "~> 0.4.0"},
      {:exconstructor, "~> 1.1.0"},
      {:httpoison, "~> 0.12.0", [override: true]},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.2.3"},
      {:phoenix_pubsub, "~> 1.0.2"},
      {:poison, "~> 3.1.0"},
      {:postgrex, "~> 0.13.3"},
      {:quantum, "~> 2.1.0-beta.1"},
      {:recaptcha, [github: "samueljseay/recaptcha"]},
      {:redix, "~> 0.6.1"},
      {:stripity_stripe, "~> 2.0.0-alpha.10"},
      {:uuid, "~> 1.1.7"},
      {:vex, [github: "CargoSense/vex"]},
    ]
  end


  # CargoSense folks are not actively maintaining
  # this package. So newer updates are not yet
  # published to Hex.pm
  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "app.setup": ["ecto.create", "event_store.create", "ecto.migrate"],
      "app.reset": ["ecto.drop", "event_store.drop", "app.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
    ]
  end
end
