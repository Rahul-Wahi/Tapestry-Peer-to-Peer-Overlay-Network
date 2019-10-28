defmodule Proj3.MixProject do
  use Mix.Project

  def project do
    [
      app: :proj3,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      #build_embedded: Mix.env == :prod,
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
     # Application.start(Proj3.Tapestry),
      extra_applications: [:logger]
      #mod: {Proj3.Tapestry, []}
    ]
  end
  def escript do
    [main_module: Proj3.Tapestry]
  end
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end