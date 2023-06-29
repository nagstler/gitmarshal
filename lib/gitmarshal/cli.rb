require 'thor'
require 'terminal-table'
require 'colorize'
require_relative 'github_fetcher'

module GitMarshal
  class CLI < Thor
    class_option :help, type: :boolean, aliases: '-h', desc: 'Display usage information'

    desc "repos", "Prints a summary of the authenticated user's GitHub repositories"
    def repos
      fetcher = GithubFetcher.new
      user = fetcher.fetch_user
      repos = fetcher.fetch_repos

      puts "GitHub Repositories for #{user}".colorize(:blue).bold

      rows = repos.map { |repo| [repo['name'], repo['description']] }
      table = Terminal::Table.new :title => "Repositories".colorize(:green), :headings => ['Name', 'Description'].map { |i| i.colorize(:magenta) }, :rows => rows
      table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      puts table
    end

    def help(*)
      puts "You can either call ./bin/gitmarshal to list all repositories or ./bin/gitmarshal repo-name to show the metrics of the given repository."
    end

    private

    def metrics(repo_name)
      fetcher = GithubFetcher.new
      user = fetcher.fetch_user

      repo = fetcher.fetch_repo_metrics(user, repo_name)

      puts "GitHub Repository Metrics for #{repo_name}".colorize(:blue).bold

      rows = [
        ['Description', repo['data']['repository']['description']],
        ['Total Commits', repo['data']['repository']['ref']['target']['history']['edges'].count],
        ['Pull Requests', repo['data']['repository']['pullRequests']['totalCount']],
        ['Issues', repo['data']['repository']['issues']['totalCount']],
        ['Stargazers', repo['data']['repository']['stargazers']['totalCount']],
        ['Forks', repo['data']['repository']['forks']['totalCount']],
        ['Languages', repo['data']['repository']['languages']['edges'].map{|lang| lang['node']['name']}.join(', ')]
      ]

      table = Terminal::Table.new :title => "Repository Metrics".colorize(:green), :headings => ['Metric', 'Value'].map { |i| i.colorize(:magenta) }, :rows => rows
      table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      puts table
    end

    def method_missing(method, *_args, &_block)
      if method =~ /[-a-zA-Z0-9_.]+/
        metrics(method.to_s)
      else
        super
      end
    end

    default_command :repos
  end
end
