# lib/gitmarshal/cli.rb

require 'thor'
require 'json'
require 'rest-client'

module GitMarshal
  class CLI < Thor
    GITHUB_API_BASE_URL = "https://api.github.com"

    desc "today", "Prints a summary of the authenticated user's GitHub activities and contributions for the current day"
    def today
      # Our code will go here
      puts "Prints Github summary for today"
    end

    private

    def headers
      { Authorization: "Bearer #{ENV['GITHUB_TOKEN']}" }
    end
  end
end
