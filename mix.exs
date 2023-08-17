defmodule Nifty.MixProject do
  use Mix.Project

  def project do
    [
      app: :nifty,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Nifty.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.28.0"},
      {:wasmex, "~> 0.8.3"},
      {:bandit, "~> 1.0-pre"},
      {:plug, "~> 1.14.2"},
      {:zigler, "~> 0.10.1", runtime: false},
      {:ex2ms, "~> 1.6"},
      {:jason, "~> 1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
