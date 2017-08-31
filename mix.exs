defmodule Plustwo.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "server",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the server folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 0.8.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      {:exfmt, "~> 0.3.0", only: :dev, runtime: false},
    ]
  end
end
