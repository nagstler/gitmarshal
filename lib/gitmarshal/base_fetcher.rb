require 'json'
require 'net/http'

class BaseFetcher
  GITHUB_API_BASE_URL = "https://api.github.com"

  protected

  def execute_http_request(req)
    Net::HTTP.start(req.uri.hostname, req.uri.port, :use_ssl => req.uri.scheme == 'https') do |http|
      http.request(req)
    end
  end

  def create_request(uri)
    Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  end

  def parse_response(response)
    JSON.parse(response.body)
  end
end
