require 'thor'
require 'date'
require 'terminal-table'
require 'colorize'
require_relative 'github_fetcher'

module GitMarshal
  class CLI < Thor
    desc "today", "Prints a summary of the authenticated user's GitHub activities and contributions for the current day"
    method_option :repo, aliases: "-r", desc: "Specify a single repository name"
    def today
      fetcher = GithubFetcher.new
      user = fetcher.fetch_user
      repos = options[:repo] ? [fetcher.fetch_repo(user["login"], options[:repo])] : fetcher.fetch_repos(user["login"])
      
      puts "GitHub Daily Activity Snapshot for #{user['login']}".colorize(:blue).bold
      puts "Date: #{Date.today}"

      repos.each do |repo|
        process_repo(fetcher, user, repo) if repo
      end
    end

    default_command :today

    private

    def process_repo(fetcher, user, repo)
      commits = fetcher.fetch_commits_for_repo(user["login"], repo["name"])
      languages = fetcher.fetch_languages_for_repo(user["login"], repo["name"]).keys.join(', ')
      today_commits = fetcher.fetch_commits_for_today(user["login"], repo["name"])

      if today_commits.size > 0
        display_summary_of_the_day(fetcher, user, repo, commits, languages, today_commits)
        display_detailed_repo_metrics(fetcher, user, repo, commits)
      end
    end

    def display_summary_of_the_day(fetcher, user, repo, commits, languages, today_commits)
      latest_commit = commits.first
      pr_raised_today = fetcher.fetch_pull_requests_for_today(user["login"], repo["name"]).count
      build_status = fetcher.fetch_build_status(user["login"], repo["name"])

      rows = [
        ['Commits Today', today_commits.size],
        ['PRs Raised Today', pr_raised_today]
      ]

      puts "\nRepository: #{repo['name']}".colorize(:yellow).bold
      puts "Languages:".colorize(:cyan)+" #{languages}"
      puts "Latest Commit Message:".colorize(:cyan)
      puts "#{latest_commit['commit']['message']}"
      puts "Latest Commit Date:".colorize(:cyan)+" #{Date.parse(latest_commit['commit']['author']['date'])}"
      puts "Build Status:".colorize(:cyan)+" #{build_status}"
      table = Terminal::Table.new :title => "Repo Summary of the Day".colorize(:green), :headings => ['Item', 'Count'].map { |i| i.colorize(:magenta) }, :rows => rows
      table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      puts table
    end

    def display_detailed_repo_metrics(fetcher, user, repo, commits)
      stargazers = fetcher.fetch_stargazers_for_repo(user["login"], repo["name"]).count
      forks = fetcher.fetch_forks_for_repo(user["login"], repo["name"]).count
      total_contributors = fetcher.fetch_contributors_for_repo(user["login"], repo["name"]).count
      open_prs = fetcher.fetch_pull_requests_for_repo(user["login"], repo["name"]).select { |pr| pr['state'] == 'open' }.count
      open_issues = fetcher.fetch_issues_for_repo(user["login"], repo["name"]).select { |issue| issue['state'] == 'open' }.count

      additional_rows = [
        ['Total Commits', commits.size],
        ['Stargazers', stargazers],
        ['Forks', forks],
        ['Total Contributors', total_contributors],
        ['Open Pull Requests', open_prs],
        ['Open Issues', open_issues]
      ]
      additional_table = Terminal::Table.new :title => "Detailed Repo Metrics".colorize(:green), :headings => ['Metric', 'Count'].map { |i| i.colorize(:magenta) }, :rows => additional_rows
      additional_table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      puts additional_table
    end
  end
end
