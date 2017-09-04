defmodule Plustwo.Umbrella.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [apps_path: "apps",
     apps: [:plustwo],
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [{:credo, "~> 0.8.6", [only: [:dev, :test], runtime: false]},
     {:dialyxir, "~> 0.5.1", [only: :dev, runtime: false]},
     {:exfmt, [github: "lpil/exfmt", only: :dev, runtime: false]}]
  end
end
