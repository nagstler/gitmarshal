# lib/gitmarshal/cli.rb

require 'thor'
require 'json'
require 'rest-client'
require 'date'
require 'terminal-table'

module GitMarshal
  class CLI < Thor
    GITHUB_API_BASE_URL = "https://api.github.com"

    desc "today", "Prints a summary of the authenticated user's GitHub activities and contributions for the current day"
    def today
      user = fetch_user
      repos = fetch_repos(user["login"])

      puts "GitHub Daily Activity Snapshot for #{user['login']}"
      puts "Date: #{Date.today}"
      
      repos.each do |repo|
        commits = fetch_commits_for_repo(user["login"], repo["name"])

        today_commits = commits.select do |commit|
          commit_author = commit['commit']['author']['name']
          commit_date = Date.parse(commit['commit']['author']['date'])
          commit_author == user['name'] && commit_date == Date.today
        end

        if today_commits.size > 0
          latest_commit = commits.first

          rows = [
            ['Commits Today', today_commits.size],
            ['Total Commits', commits.size],
            ['Latest Commit Message', latest_commit['commit']['message']],
            ['Latest Commit Date', Date.parse(latest_commit['commit']['author']['date'])]
          ]

          puts "\nRepository: #{repo['name']}"
          table = Terminal::Table.new :rows => rows
          puts table
        end
      end
    end

    default_command :today

    private

    def fetch_user
      response = RestClient.get("#{GITHUB_API_BASE_URL}/user", headers)
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

    def headers
      { Authorization: "Bearer #{ENV['GITHUB_TOKEN']}" }
    end
  end
end
