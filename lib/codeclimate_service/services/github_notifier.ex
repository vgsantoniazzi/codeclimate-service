defmodule CodeclimateService.Services.GithubNotifier do
  def notify(data, status) do
    send_status(data["pull_request"]["head"]["repo"]["full_name"], data["pull_request"]["head"]["sha"], json(status))
  end

  def send_status(repository, sha, json) do
    case HTTPoison.post("https://api.github.com/repos/#{repository}/statuses/#{sha}", Poison.encode!(json)) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts body
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def json(status) do
    %{
      "state" => "#{status}",
      "target_url" => "https://example.com/build/status",
      "description" => "The build is running!",
      "context" => "continuous-integration/codeclimate"
    }
  end
end
