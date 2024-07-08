# frozen_string_literal: true

require 'gitmarshal/version'
require 'gitmarshal/cli'
require 'gitmarshal/github_fetcher'

module Gitmarshal
  class Error < StandardError; end

  GITHUB_TOKEN = ENV["GITHUB_TOKEN"]
end
