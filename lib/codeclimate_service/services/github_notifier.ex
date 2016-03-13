defmodule CodeclimateService.Services.GithubNotifier do
  def notify(data, status) do
    send_status(data["pull_request"]["head"]["repo"]["full_name"], data["pull_request"]["head"]["sha"], json(status))
  end

  def send_status(repository, sha, json) do
    case HTTPoison.post(url(repository, sha), Poison.encode!(json), header) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts body
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def url(repository, sha) do
    "https://api.github.com/repos/#{repository}/statuses/#{sha}/?access_token=#{access_token}"
  end

  def json(status) do
    %{
      "state" => "#{status}",
      "target_url" => "https://example.com/build/status",
      "description" => "The build is running!",
      "context" => "continuous-integration/codeclimate"
    }
  end

  def header do
    [{"Accept", "application/vnd.github.v3+json"}]
  end

  def access_token do
    Dotenv.get("GITHUB_ACCESS_TOKEN")
  end
end
