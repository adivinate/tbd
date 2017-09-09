defmodule Plustwo.Umbrella.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [
      apps_path: "apps",
      apps: [:plustwo],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end


  defp deps do
    [
      {:credo, "~> 0.8.6", [only: [:dev, :test], runtime: false]},
      {:dialyxir, "~> 0.5.1", [only: :dev, runtime: false]},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:exfmt, [github: "lpil/exfmt", only: :dev, runtime: false]},
      {:mix_test_watch, "~> 0.5.0", [only: :dev, runtime: false]},
    ]
  end
end
