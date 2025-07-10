defmodule DepsChangelog.MixProject do
  use Mix.Project

  def project do
    [
      app: :deps_changelog,
      version: "0.3.3",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      name: "deps_changelog",
      docs: docs()
    ]
  end

  defp description,
    do: "Capture dep's CHANGELOG updates during `mix deps.update` and collect in new file"

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ],
      formatters: ["html"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      update: ["deps.changelog deps.update --all"],
      ci: [
        "format --check-formatted",
        "deps.unlock --check-unused",
        "credo",

        # Order might be important,
        # see https://elixirforum.com/t/cant-run-hex-mix-tasks-in-alias/65649/13
        fn _ -> Mix.ensure_application!(:hex) end,
        "hex.audit"
      ]
    ]
  end

  defp package do
    [
      name: "deps_changelog",
      maintainers: ["Steffen Beyer"],
      licenses: ["0BSD"],
      links: %{"GitHub" => "https://github.com/serpent213/deps_changelog"}
    ]
  end
end
