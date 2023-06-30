require_relative 'base_fetcher'

class MetricFetcher < BaseFetcher
  def fetch_today_commits_count(owner, repo_name)
    today = Date.today.strftime("%Y-%m-%d")
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/commits?since=#{today}T00:00:00Z")

    req = create_request(uri)

    response = execute_http_request(req)
    commits_data = parse_response(response)

    commits_data.size
  end

  def fetch_pr_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/pulls?state=all")

    req = create_request(uri)

    response = execute_http_request(req)
    pr_data = parse_response(response)

    pr_data.size
  end

  def fetch_issue_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/issues?state=all")

    req = create_request(uri)

    response = execute_http_request(req)
    issues_data = parse_response(response)

    issues_data.size
  end

  def fetch_star_count(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}")

    req = create_request(uri)

    response = execute_http_request(req)
    star_data = parse_response(response)

    star_data['stargazers_count']
  end
end
