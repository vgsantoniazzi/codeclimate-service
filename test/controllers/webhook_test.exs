defmodule Test.Controllers.Webhook do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock
  alias CodeclimateService.Services.GithubNotifier
  alias CodeclimateService.Controllers.Webhook

  test "When GitHub event is a pull_request" do
    params = %{"pull_request" => %{"action" => "created", "head" => %{"repo" => %{"full_name" => "codeclimate_service"}}}}
    conn = conn(:post, "/webhook", params)
      |> Plug.Conn.put_req_header("x-github-event", "pull_request")
    opts = Webhook.init [ action: :create ]
    with_mock GithubNotifier, [notify: fn(_params, _status) -> true end] do
      conn = Webhook.call(conn, opts)
      assert conn.status == 201
      assert conn.resp_body == "{\"message\":\"Created new build\"}"
      assert called GithubNotifier.notify(params, "pending")
    end
  end

  test "When GitHub event is not a pull_request" do
    params = %{"action" => "opened"}
    conn = conn(:post, "/webhook", params)
      |> Plug.Conn.put_req_header("x-github-event", "ping")
    opts = Webhook.init [ action: :create ]
    with_mock GithubNotifier, [notify: fn(_params, _status) -> true end] do
      conn = Webhook.call(conn, opts)
      assert conn.status == 200
      assert conn.resp_body == "{\"message\":\"Is not a pull request, moving on\"}"
      refute called GithubNotifier.notify(params, "pending")
    end
  end
end
