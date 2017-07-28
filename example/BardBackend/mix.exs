defmodule BardBackend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bard_backend,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      compilers: compilers(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {BardBackend.Application, []},
      extra_applications: [:logger]
    ]
  end

  def compilers do
    [:phoenix] ++ Mix.compilers
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},

      {:cowboy, "~> 1.0"},
      {:phoenix, "~> 1.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:bard, path: Path.join(__DIR__, "../../") }
    ]
  end
end
