# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :codeclimate_service, CodeclimateService.Repos.Main,
  adapter: Ecto.Adapters.Postgres,
  database: "codeclimate_service_main",
  username: "user",
  password: "pass",
  hostname: "localhost"


config :sugar, router: CodeclimateService.Router

