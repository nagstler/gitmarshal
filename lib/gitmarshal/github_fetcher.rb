require 'json'
require 'net/http'

class GithubFetcher
  GITHUB_API_BASE_URL = "https://api.github.com/graphql"

  def fetch_repos
    query = <<~GRAPHQL
      query {
        viewer {
          repositories(first: 100) {
            nodes {
              name
              description
            }
          }
        }
      }
    GRAPHQL
  
    response = execute_graphql_query(query)
    JSON.parse(response.body)["data"]["viewer"]["repositories"]["nodes"]
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
