defmodule CodeclimateService.Services.GithubNotifier do
  alias CodeclimateService.Services.GithubNotifier

  def notify(data, status) do
    send_status(data["pull_request"]["head"]["repo"]["full_name"], data["pull_request"]["head"]["sha"], body(status))
  end

  def send_status(repository, sha, body) do
    HTTPoison.post(url(repository, sha), Poison.encode!(body), header)
  end

  def url(repository, sha) do
    "https://api.github.com/repos/#{repository}/statuses/#{sha}?access_token=#{access_token}"
  end

  def body(status) do
    %{
      "state" => "#{status}",
      "target_url" => "https://example.com/build/status",
      "description" => description(status),
      "context" => "continuous-integration/codeclimate"
    }
  end

  def description(status) do
    case status do
      "pending" ->
        "Build is running!"
      "failure" ->
        "Error! You need improve your code!"
      "success" ->
        "Yay! Everything is clean! Go ahead!"
      _ ->
        "Oops! Something is not correct with this service!"
    end
  end

  def header do
    [{"Accept", "application/vnd.github.v3+json"}]
  end

  def access_token do
    Dotenv.get("GITHUB_ACCESS_TOKEN")
  end
end
