defmodule ChangelogIgniter.MixProject do
  use Mix.Project

  def project do
    [
      app: :deps_changelog,
      version: "0.3.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:igniter, "~> 0.5", only: [:dev]}
    ]
  end

  defp aliases do
    [
      update: ["deps.changelog deps.update --all"]
    ]
  end
end
