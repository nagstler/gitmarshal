require 'json'
require 'net/http'
require 'date'

class GithubFetcher
  GITHUB_API_BASE_URL = "https://api.github.com"

  def fetch_repos
    uri = URI("#{GITHUB_API_BASE_URL}/user/repos")
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
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    repo_data = JSON.parse(response.body)
  
    last_updated_at = repo_data["updated_at"]

    today_commits_count = fetch_today_commits_count(owner, repo_name)
    today_pull_requests_count = fetch_today_pull_requests_count(owner, repo_name)

  
    {
      "name" => repo_data["name"],
      "description" => repo_data["description"],
      "watchers_count" => repo_data["watchers_count"],
      "forks_count" => repo_data["forks_count"],
      "open_issues_count" => repo_data["open_issues_count"],
      "default_branch" => repo_data["default_branch"],
      "languages" => fetch_languages(owner, repo_name),
      "commits_count" => fetch_commits_count(owner, repo_name),
      "pull_requests_count" => fetch_pull_requests_count(owner, repo_name),
      "closed_pull_requests_count" => fetch_closed_pull_requests_count(owner, repo_name),
      "open_pull_requests_count" => fetch_open_pull_requests_count(owner, repo_name),
      "issues_count" => fetch_issues_count(owner, repo_name),
      "closed_issues_count" => fetch_closed_issues_count(owner, repo_name),
      "stargazers_count" => repo_data["stargazers_count"],
      "contributors_count" => fetch_contributors_count(owner, repo_name),
      "license" => fetch_license(owner, repo_name),
      "last_updated_at" => last_updated_at,
      "today_commits_count" => today_commits_count,
      "today_pull_requests_count" => today_pull_requests_count
    }
  end

  def fetch_today_commits_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/commits?since=#{today}T00:00:00Z")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    commits_data = JSON.parse(response.body)
  
    commits_data.size
  end

  def fetch_today_pull_requests_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=all")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    pull_requests = JSON.parse(response.body)
  
    today_pull_requests = pull_requests.select { |pr| pr['created_at'].start_with?(today) }
  
    today_pull_requests.size
  end
  
  
  def fetch_closed_pull_requests_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=closed")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    pull_requests = JSON.parse(response.body)
    pull_requests.size
  end
  
  def fetch_open_pull_requests_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=open")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    pull_requests = JSON.parse(response.body)
    pull_requests.size
  end
  
  def fetch_issues_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    issues = JSON.parse(response.body)
    issues.size
  end
  
  def fetch_closed_issues_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues?state=closed")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    issues = JSON.parse(response.body)
    issues.size
  end

  def fetch_today_closed_pull_requests_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=closed")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    pull_requests = JSON.parse(response.body)
  
    today_closed_pull_requests = pull_requests.select { |pr| pr['created_at'].start_with?(today) }
  
    today_closed_pull_requests.size
  end

  def fetch_today_open_pull_requests_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=open")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    pull_requests = JSON.parse(response.body)
  
    today_open_pull_requests = pull_requests.select { |pr| pr['created_at'].start_with?(today) }
  
    today_open_pull_requests.size
  end

  def fetch_today_issues_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    issues = JSON.parse(response.body)
  
    today_issues = issues.select { |issue| issue['created_at'].start_with?(today) }
  
    today_issues.size
  end

  def fetch_today_closed_issues_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues?state=closed")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    issues = JSON.parse(response.body)
  
    today_closed_issues = issues.select { |issue| issue['closed_at'] && issue['closed_at'].start_with?(today) }
  
    today_closed_issues.size
  end

  def fetch_today_open_issues_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues?state=open")
  
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    issues = JSON.parse(response.body)
  
    today_open_issues = issues.select { |issue| issue['created_at'].start_with?(today) }
  
    today_open_issues.size
  end
  
  
  
  
  
  def fetch_contributors_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/contributors")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    contributors = JSON.parse(response.body)
    contributors.size
  end
  
  def fetch_license(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/license")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
    response = execute_http_request(req)
    license_data = JSON.parse(response.body)
    license_data["license"] if license_data.key?("license")
  end

  def fetch_languages(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/languages")

    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )

    response = execute_http_request(req)
    languages_data = JSON.parse(response.body)
    languages_data.keys
  end

  def fetch_commits_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/commits")

    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )

    response = execute_http_request(req)
    commits_data = JSON.parse(response.body)
    commits_data.size
  end

  def fetch_pull_requests_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls")

    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )

    response = execute_http_request(req)
    pull_requests_data = JSON.parse(response.body)
    pull_requests_data.size
  end

  def fetch_latest_commit(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/commits")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )

    response = execute_http_request(req)
    commits = JSON.parse(response.body)

    commits.first # Return the latest commit
  end

  def fetch_user
    uri = URI("#{GITHUB_API_BASE_URL}/user")
    req = Net::HTTP::Get.new(uri,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GITHUB_TOKEN']}"
    )
  
    response = execute_http_request(req)
    user_data = JSON.parse(response.body)
    user_data['login'] # return the username
  end
  
  private

  def execute_http_request(req)
    Net::HTTP.start(req.uri.hostname, req.uri.port, :use_ssl => req.uri.scheme == 'https') do |http|
      http.request(req)
    end
  end

  def request(uri, req)
    Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end
  end
end
