defmodule CodeclimateService.Router do
  use Sugar.Router
  plug Sugar.Plugs.HotCodeReload

  post "/webhook", CodeclimateService.Controllers.Webhook, :create
end
