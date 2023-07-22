require_relative "metric_fetcher"
require "octokit"

class GithubFetcher
  def initialize
    Octokit.configure do |config|
      config.access_token = ENV["GITHUB_TOKEN"]
    end
  end

  def fetch_user
    Octokit.user.login
  end

  def fetch_repos
    Octokit.repositories.map do |repo|
      {
        "name" => repo.name,
        "issues" => repo.open_issues_count,
        "stargazers" => repo.stargazers_count,
        "forks" => repo.forks_count,
      }
    end
  end

  def fetch_today_repo_metrics(user, repo_name)
    {
      "name" => repo_name,
      "forks_count" => fetch_today_forks_count(user, repo_name),
      "open_issues_count" => fetch_today_open_issues_count(user, repo_name),
      "commits_count" => fetch_today_commits_count(user, repo_name),
      "pull_requests_count" => fetch_today_pull_requests_count(user, repo_name),
      "closed_pull_requests_count" => fetch_today_closed_pull_requests_count(user, repo_name),
      "open_pull_requests_count" => fetch_today_open_pull_requests_count(user, repo_name),
      "issues_count" => fetch_today_issues_count(user, repo_name),
      "closed_issues_count" => fetch_today_closed_issues_count(user, repo_name),
    }
  end

  def fetch_repo_metrics(user, repo_name)
    begin
      repo = Octokit.repository("#{user}/#{repo_name}")
    rescue Octokit::NotFound
      puts "The repository #{user}/#{repo_name} was not found. Please check the repository name and try again."
      exit
    end
    {
      "name" => repo.name,
      "description" => repo.description,
      "default_branch" => repo.default_branch,
      "last_updated_at" => repo.updated_at,
      "watchers_count" => repo.watchers_count,
      "forks_count" => repo.forks_count,
      "open_issues_count" => repo.open_issues_count,
      "commits_count" => Octokit.commits("#{user}/#{repo_name}").count,
      "pull_requests_count" => Octokit.pull_requests("#{user}/#{repo_name}").count,
      "closed_pull_requests_count" => Octokit.pull_requests("#{user}/#{repo_name}", state: "closed").count,
      "open_pull_requests_count" => Octokit.pull_requests("#{user}/#{repo_name}", state: "open").count,
      "issues_count" => Octokit.issues("#{user}/#{repo_name}").count,
      "closed_issues_count" => Octokit.issues("#{user}/#{repo_name}", state: "closed").count,
      "stargazers_count" => repo.stargazers_count,
      "contributors_count" => Octokit.contributors("#{user}/#{repo_name}").count,
    }
  end

  def fetch_latest_commit(user, repo_name)
    Octokit.commits("#{user}/#{repo_name}").first
  end

  def fetch_today_commits_count(user, repo_name)
    Octokit.commits("#{user}/#{repo_name}").count do |commit|
      commit.commit.committer.date.to_date == Date.today
    end
  end

  def fetch_today_pull_requests_count(user, repo_name)
    Octokit.pull_requests("#{user}/#{repo_name}").count do |pr|
      pr.created_at.to_date == Date.today
    end
  end

  def fetch_today_closed_pull_requests_count(user, repo_name)
    Octokit.pull_requests("#{user}/#{repo_name}", state: "closed").count do |pr|
      pr.closed_at.to_date == Date.today
    end
  end

  def fetch_today_open_pull_requests_count(user, repo_name)
    Octokit.pull_requests("#{user}/#{repo_name}", state: "open").count do |pr|
      pr.created_at.to_date == Date.today
    end
  end

  def fetch_today_issues_count(user, repo_name)
    Octokit.issues("#{user}/#{repo_name}").count do |issue|
      issue.created_at.to_date == Date.today
    end
  end

  def fetch_today_closed_issues_count(user, repo_name)
    Octokit.issues("#{user}/#{repo_name}", state: "closed").count do |issue|
      issue.closed_at.to_date == Date.today
    end
  end

  def fetch_today_open_issues_count(user, repo_name)
    Octokit.issues("#{user}/#{repo_name}", state: "open").count do |issue|
      issue.created_at.to_date == Date.today
    end
  end

  def fetch_today_forks_count(user, repo_name)
    Octokit.forks("#{user}/#{repo_name}").count do |fork|
      fork.created_at.to_date == Date.today
    end
  end
end
