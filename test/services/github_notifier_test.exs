defmodule Test.Services.GithubNotifier do
  use ExUnit.Case, async: false
  import Mock
  alias CodeclimateService.Services.GithubNotifier

  test "send github request correctly" do
    with_mock HTTPoison, [post: fn(_url, _body, _header) -> {:ok, "success"} end] do
      GithubNotifier.notify(%{"pull_request" => %{"head" => %{"sha" => "12344", "repo" => %{"full_name" => "vgsantoniazzi/codeclimate_service"}}}}, "pending")
      assert called HTTPoison.post(GithubNotifier.url("vgsantoniazzi/codeclimate_service", "12344"), Poison.encode!(GithubNotifier.body("pending")), GithubNotifier.header)
    end
  end

  test "json with status and description as pending" do
    assert GithubNotifier.body("pending") ==
      %{"context" => "continuous-integration/codeclimate",
        "description" => "Build is running!",
        "state" => "pending",
        "target_url" => "https://example.com/build/status"}
  end

  test "json with status and description as success" do
    assert GithubNotifier.body("success") ==
      %{"context" => "continuous-integration/codeclimate",
        "description" => "Yay! Everything is clean! Go ahead!",
        "state" => "success",
        "target_url" => "https://example.com/build/status"}
  end

  test "json with status and description as failure" do
    assert GithubNotifier.body("failure") ==
      %{"context" => "continuous-integration/codeclimate",
        "description" => "Error! You need improve your code!",
        "state" => "failure",
        "target_url" => "https://example.com/build/status"}
  end

  test "valid GitHub version 3 header" do
    assert GithubNotifier.header == [{"Accept", "application/vnd.github.v3+json"}]
  end

  test "get GitHub access token" do
    assert GithubNotifier.access_token == "6eb44614cc8f87e09709e38c59aac7c5415e8bc1"
  end

  test "correct GitHub api URL" do
    assert GithubNotifier.url("vgsantoniazzi/codeclimate_service", 1) == "https://api.github.com/repos/vgsantoniazzi/codeclimate_service/statuses/1?access_token=6eb44614cc8f87e09709e38c59aac7c5415e8bc1"
  end
end
