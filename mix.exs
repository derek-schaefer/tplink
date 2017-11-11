defmodule TPLink.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tplink,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
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
      {:poison, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
