require "thor"
require "terminal-table"
require "colorize"
require_relative "github_fetcher"

module GitMarshal
  class CLI < Thor
    class_option :help, type: :boolean, aliases: "-h", desc: "Display usage information"
    class_option :today, type: :boolean, aliases: "-t", desc: 'Display today\'s repository metrics instead of overall metrics'

    desc "repos", "Prints a summary of the authenticated user's GitHub repositories"

    def repos
      begin
        fetcher = GithubFetcher.new
        user = fetcher.fetch_user
        repos = fetcher.fetch_repos

        puts "GitHub Repositories for #{user}".colorize(:blue).bold

        rows = repos.map do |repo|
          [
            repo["name"],
            repo["issues"],
            repo["stargazers"],
            repo["forks"],
          ]
        end

        table = Terminal::Table.new :title => "Repositories".colorize(:green).bold,
                                    :headings => ["Name", "Issues", "Stargazers", "Forks"].map { |i| i.colorize(:magenta).bold },
                                    :rows => rows

        table.style = { :border_x => "=", :border_i => "x", :alignment => :center }
        puts table
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    def help(*)
      rows = []
      rows << ["gitmarshal", "List all repositories of the authenticated user"]
      rows << ["gitmarshal repo-name", "Show the overall metrics of the given repository"]
      rows << ["gitmarshal repo-name --today", "Show today's metrics of the given repository"]
    
      table = Terminal::Table.new :rows => rows
      table.title = "GitMarshal Commands".colorize(:green).bold
      table.headings = ['Command', 'Description'].map { |i| i.colorize(:magenta).bold }
      table.style = { :border_x => "=", :border_i => "x", :alignment => :left }
      puts table
    end

    private

    def metrics(repo_name, today_option = false)
      fetcher = GithubFetcher.new
      user = fetcher.fetch_user

      repo = today_option ? fetcher.fetch_today_repo_metrics(user, repo_name) : fetcher.fetch_repo_metrics(user, repo_name)

      if today_option
        rows = prepare_table_rows_for_today(repo)
        # Display latest commit
        latest_commit = fetcher.fetch_latest_commit(user, repo_name)
        if latest_commit
          rows << ["Latest Commit Date", latest_commit["commit"]["committer"]["date"]]
          rows << ["Latest Commit Message", wrap_text(latest_commit["commit"]["message"])]
        end
        # Display today's metrics in a table
        display_table("Today's Repository Metrics", rows)
      else
        rows = prepare_table_rows(repo)
        # Display latest commit
        latest_commit = fetcher.fetch_latest_commit(user, repo_name)
        if latest_commit
          rows << ["Latest Commit Date", latest_commit["commit"]["committer"]["date"]]
          rows << ["Latest Commit Message", wrap_text(latest_commit["commit"]["message"])]
        end
        # Display overall metrics in a table
        display_table("Repository Metrics", rows)
      end
    end

    private

    def wrap_text(text, max_width = 50)
      text.gsub(/(.{1,#{max_width}})(\s+|\Z)/, "\\1\n")
    end

    def prepare_table_rows_for_today(repo)
      [
        ["Repository Name", repo["name"]],
        ["Total Commits", repo["commits_count"].to_s],
        ["Pull Requests", repo["pull_requests_count"].to_s],
        ["Forks", repo["forks_count"].to_s],
        ["Issues", repo["issues_count"].to_s],
        ["Open Issues", repo["open_issues_count"].to_s],
        ["Closed Issues", repo["closed_issues_count"].to_s],
        ["Open Pull Requests", repo["open_pull_requests_count"].to_s],
        ["Closed Pull Requests", repo["closed_pull_requests_count"].to_s],
      ]
    end

    def prepare_table_rows(repo)
      [
        ["Repository Name", repo["name"]],
        ["Default Branch", repo["default_branch"]],
        ["Last Updated At", repo["last_updated_at"]],
        ["Total Commits", repo["commits_count"].to_s],
        ["Pull Requests", repo["pull_requests_count"].to_s],
        ["Forks", repo["forks_count"].to_s],
        ["Watchers", repo["watchers_count"].to_s],
        ["Issues", repo["issues_count"].to_s],
        ["Open Issues", repo["open_issues_count"].to_s],
        ["Closed Issues", repo["closed_issues_count"].to_s],
        ["Open Pull Requests", repo["open_pull_requests_count"].to_s],
        ["Closed Pull Requests", repo["closed_pull_requests_count"].to_s],
        ["Contributors", repo["contributors_count"].to_s],
        ["Stargazers", repo["stargazers_count"].to_s],
      ]
    end

    def display_table(title, rows)
      table = Terminal::Table.new :title => title.colorize(:blue).bold,
                                  :headings => ["Metric", "Data"].map { |i| i.colorize(:magenta).bold },
                                  :rows => rows

      table.style = { :border_x => "=", :border_i => "x", :alignment => :center }

      puts table
    end

    def method_missing(method, *args, &_block)
      if method =~ /[-a-zA-Z0-9_.]+/
        today_option = args.include?("--today")
        metrics(method.to_s, today_option)
      else
        super
      end
    end

    default_command :repos
  end
end
