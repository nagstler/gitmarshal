# frozen_string_literal: true

require_relative "gitmarshal/version"

module Gitmarshal
  class Error < StandardError; end
  
  GITHUB_TOKEN = ENV['GITHUB_TOKEN']
end
