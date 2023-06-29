require 'json'
require 'rest-client'
require 'date'

class GithubFetcher
  GITHUB_API_BASE_URL = "https://api.github.com"

  def fetch_user
    response = RestClient.get("#{GITHUB_API_BASE_URL}/user", headers)
    JSON.parse(response.body)
  end

  def fetch_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}", headers)
    JSON.parse(response.body)
  end

  def fetch_repos(username)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/users/#{username}/repos", headers)
    JSON.parse(response.body)
  end

  def fetch_commits_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/commits", headers)
    JSON.parse(response.body)
  end

  def fetch_commits_for_today(username, repo_name)
    commits = fetch_commits_for_repo(username, repo_name)
    commits.select do |commit|
      commit_author = commit['commit']['author']['name']
      commit_date = Date.parse(commit['commit']['author']['date'])
      commit_author == fetch_user['name'] && commit_date == Date.today
    end
  end

  def fetch_pull_requests_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/pulls", headers)
    JSON.parse(response.body)
  end

  def fetch_pull_requests_for_today(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/pulls?state=all", headers)
    pull_requests = JSON.parse(response.body)
    
    today_pull_requests = pull_requests.select do |pr|
      pr_date = Date.parse(pr['created_at'])
      pr_date == Date.today
    end
    
    today_pull_requests
  end

  def fetch_issues_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/issues", headers)
    JSON.parse(response.body)
  end

  def fetch_stargazers_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/stargazers", headers)
    JSON.parse(response.body)
  end

  def fetch_forks_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/forks", headers)
    JSON.parse(response.body)
  end

  def fetch_languages_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/languages", headers)
    JSON.parse(response.body)
  end

  def fetch_contributors_for_repo(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/contributors", headers)
    JSON.parse(response.body)
  end

  def fetch_build_status(username, repo_name)
    response = RestClient.get("#{GITHUB_API_BASE_URL}/repos/#{username}/#{repo_name}/actions/runs", headers)
    workflow_runs = JSON.parse(response.body)['workflow_runs']
    
    latest_run = workflow_runs.first
    latest_run ? latest_run['conclusion'] : 'No workflow runs found'
  end

  private
  
  def headers
    { Authorization: "Bearer #{ENV['GITHUB_TOKEN']}" }
  end
end
