defmodule CodeclimateService.Controllers.Webhook do
  use Sugar.Controller

  def create(conn, _args) do
    if get_req_header(conn, "X-GitHub-Event") == ["pull_request"] do
      conn |> status(201) |> json(%{"message" => conn.params })
     else
       conn |> status(200) |>json(%{"message" => "Is not a pull request, moving on"})
     end
  end
end
