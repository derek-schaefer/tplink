defmodule Tplink.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tplink,
      version: "0.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    "An Elixir library for interacting with TPLink devices"
  end

  defp package do
    [
      maintainers: ["Derek Schaefer"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/derek-schaefer/tplink"}
    ]
  end
end
