require 'json'
require 'net/http'

class GithubFetcher
  GITHUB_API_BASE_URL = "https://api.github.com/graphql"
  GITHUB_REST_API_BASE_URL = "https://api.github.com"

  def fetch_repos
    uri = URI("#{GITHUB_REST_API_BASE_URL}/user/repos")
    req = Net::HTTP::Get.new(uri, 
      "Content-Type" => "application/json", 
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )

    response = execute_http_request(req)

    repos = JSON.parse(response.body).map do |repo|
      {
        'name' => repo['name'],
        'issues' => repo['open_issues_count'],
        'stargazers' => repo['stargazers_count'],
        'forks' => repo['forks_count']
      }
    end
    repos
  end

  def fetch_repo_metrics(owner, repo_name)
    query = <<~GRAPHQL
      query {
        repository(owner: "#{owner}", name: "#{repo_name}") {
          name
          description
          pullRequests {
            totalCount
          }
          issues {
            totalCount
          }
          stargazers {
            totalCount
          }
          forks {
            totalCount
          }
          languages(first: 100) {
            edges {
              node {
                name
              }
            }
          }
          ref(qualifiedName: "main") {
            target {
              ... on Commit {
                history(first: 100) {
                  edges {
                    node {
                      committedDate
                      message
                    }
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    response = execute_graphql_query(query)
    JSON.parse(response.body)
  end

  def fetch_user
    query = <<~GRAPHQL
      query {
        viewer {
          login
        }
      }
    GRAPHQL
  
    response = execute_graphql_query(query)
    JSON.parse(response.body)["data"]["viewer"]["login"]
  end
  

  private

  def execute_http_request(req)
    Net::HTTP.start(req.uri.hostname, req.uri.port, :use_ssl => req.uri.scheme == 'https') do |http|
      http.request(req)
    end
  end

  def execute_graphql_query(query)
    uri = URI(GITHUB_API_BASE_URL)
    req = Net::HTTP::Post.new(uri, 
      "Content-Type" => "application/json", 
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    req.body = {query: query}.to_json
    Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end
  end
end
