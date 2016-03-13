defmodule CodeclimateService.Controllers.Webhook do
  use Sugar.Controller

  def create(conn, _args) do
    if get_req_header(conn, "x-github-event") == ["pull_request"] do
      CodeclimateService.Services.GithubNotifier.notify(conn.params, "pending")
      conn |> status(201) |> json(%{"message" => "Created new build"})
    else
      conn |> status(200) |> json(%{"message" => "Is not a pull request, moving on"})
    end
  end
end
