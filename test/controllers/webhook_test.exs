defmodule Test.Controllers.Webhook do
  use ExUnit.Case, async: true
  use Plug.Test

  test "When GitHub event is a pull_request" do
    conn = conn(:post, "/webhook", %{"pull_request" => %{"action" => "created", "head" => %{"repo" => %{"full_name" => "codeclimate_service"}}}})
      |> Plug.Conn.put_req_header("x-github-event", "pull_request")
    opts = CodeclimateService.Controllers.Webhook.init [ action: :create ]
    conn = CodeclimateService.Controllers.Webhook.call(conn, opts)
    assert conn.status == 201
    assert conn.resp_body == "{\"message\":\"Created new build\"}"
  end

  test "When GitHub event is not a pull_request" do
    conn = conn(:post, "/webhook", %{"action" => "opened"})
      |> Plug.Conn.put_req_header("x-github-event", "ping")
    opts = CodeclimateService.Controllers.Webhook.init [ action: :create ]
    conn = CodeclimateService.Controllers.Webhook.call(conn, opts)
    assert conn.status == 200
    assert conn.resp_body == "{\"message\":\"Is not a pull request, moving on\"}"
  end
end
