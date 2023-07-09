require 'thor'
require 'terminal-table'
require 'colorize'
require_relative 'github_fetcher'

module GitMarshal
  class CLI < Thor
    class_option :help, type: :boolean, aliases: '-h', desc: 'Display usage information'

    desc "repos", "Prints a summary of the authenticated user's GitHub repositories"
    def repos
      begin
        fetcher = GithubFetcher.new
        user = fetcher.fetch_user
        repos = fetcher.fetch_repos
    
        puts "GitHub Repositories for #{user}".colorize(:blue).bold
    
        rows = repos.map do |repo|
          [
            repo['name'],
            repo['issues'],
            repo['stargazers'],
            repo['forks']
          ]
        end
    
        table = Terminal::Table.new :title => "Repositories".colorize(:green).bold,
                                    :headings => ['Name', 'Issues', 'Stargazers', 'Forks'].map { |i| i.colorize(:magenta).bold },
                                    :rows => rows
    
        table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
        puts table
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end
    

    def help(*)
      puts "You can either call ./bin/gitmarshal to list all repositories or ./bin/gitmarshal repo-name to show the metrics of the given repository."
    end

    private

    def metrics(repo_name)
      fetcher = GithubFetcher.new
      user = fetcher.fetch_user
    
      repo = fetcher.fetch_repo_metrics(user, repo_name)
    
      # Print repository name and other details as introduction
      puts "GitHub Repository: #{repo['name']}".colorize(:blue).bold
      puts "Description: #{repo['description']}"
      puts "Default Branch: #{repo['default_branch']}"
      puts "Last Updated At: #{repo['last_updated_at']}"

      puts "x======================================x"

      # Display latest commit
      latest_commit = fetcher.fetch_latest_commit(user, repo_name)
      if latest_commit
        puts "Latest Commit:".colorize(:blue).bold
        puts "Commit Date: #{latest_commit['commit']['committer']['date']}"
        puts "Commit Message: #{latest_commit['commit']['message']}"
      end
      
      # Display repository metrics in a table
      rows = [
        ['Total Commits', repo['commits_count']],
        ['Pull Requests', repo['pull_requests_count']],
        ['Forks', repo['forks_count']],
        ['Watchers', repo['watchers_count']],
        ['Issues', repo['issues_count']],
        ['Open Issues', repo['open_issues_count']],
        ['Closed Issues', repo['closed_issues_count']],
        ['Open Pull Requests', repo['open_pull_requests_count']],
        ['Closed Pull Requests', repo['closed_pull_requests_count']],
        ['Contributors', repo['contributors_count']],
        ['Stargazers', repo['stargazers_count']]
      ]
    
      table = Terminal::Table.new :title => "Repository Metrics".colorize(:blue).bold, :headings => ['Metric', 'Count'].map { |i| i.colorize(:magenta).bold }, :rows => rows
      table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      puts table

      # # Display today's repository metrics in a table
      # today_rows = [
      #   ['Today\'s Total Commits', fetcher.fetch_today_commits_count(user, repo_name)],
      #   ['Today\'s Pull Requests', fetcher.fetch_today_pull_requests_count(user, repo_name)],
      #   ['Today\'s Closed Pull Requests', fetcher.fetch_today_closed_pull_requests_count(user, repo_name)],
      #   ['Today\'s Open Pull Requests', fetcher.fetch_today_open_pull_requests_count(user, repo_name)],
      #   ['Today\'s Issues', fetcher.fetch_today_issues_count(user, repo_name)],
      #   ['Today\'s Closed Issues', fetcher.fetch_today_closed_issues_count(user, repo_name)],
      #   ['Today\'s Open Issues', fetcher.fetch_today_open_issues_count(user, repo_name)]
      # ]

      # today_table = Terminal::Table.new :title => "Today's Repository Metrics".colorize(:green).bold, :headings => ['Metric', 'Count'].map { |i| i.colorize(:magenta).bold }, :rows => today_rows
      # today_table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
      # puts today_table
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
