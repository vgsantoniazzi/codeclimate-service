defmodule Test.Controllers.Webhook do
  use ExUnit.Case, async: true
  use Plug.Test

  test "When GitHub event is a pull_request" do
    conn = conn(:post, "/webhook", %{"id" => 1})
      |> Plug.Conn.put_req_header("X-GitHub-Event", "pull_request")
    opts = CodeclimateService.Controllers.Webhook.init [ action: :create ]
    conn = CodeclimateService.Controllers.Webhook.call(conn, opts)
    assert conn.status == 201
    assert conn.resp_body == "{\"message\":{\"id\":1}}"
  end

  test "When GitHub event is not a pull_request" do
    conn = conn(:post, "/webhook", %{"id" => 1})
      |> Plug.Conn.put_req_header("X-GitHub-Event", "ping")
    opts = CodeclimateService.Controllers.Webhook.init [ action: :create ]
    conn = CodeclimateService.Controllers.Webhook.call(conn, opts)
    assert conn.status == 200
    assert conn.resp_body == "{\"message\":\"Is not a pull request, moving on\"}"
  end
end
