defmodule CodeclimateService.Mixfile do
  use Mix.Project

  def project do
    [app: :codeclimate_service,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     elixirc_paths: ["lib"]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, dot_env(Mix.env)]]
  end

  defp dot_env(:dev), do: :dotenv
  defp dot_env(_), do: dot_env
  defp dot_env, do: :dotenv

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :sugar, "~> 0.4.6" },
      { :postgrex, ">= 0.0.0" },
      { :ecto, "~> 2.0.0-beta", override: true },
      { :plug, github: "vgsantoniazzi/plug", override: true },
      { :httpoison, "~> 0.8.0" },
      { :dotenv, "~> 2.0.0" },
      { :mock, "~> 0.1.1" }
    ]
  end
end
