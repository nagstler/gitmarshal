# frozen_string_literal: true

require_relative "lib/gitmarshal/version"

Gem::Specification.new do |spec|
  spec.name          = "gitmarshal"
  spec.version       = Gitmarshal::VERSION
  spec.authors       = ["Nagendra Dhanakeerthi"]
  spec.email         = ["nagendra.dhanakeerthi@gmail.com"]

  spec.summary       = "Command-line tool for fetching and displaying GitHub repository metrics"
  spec.description   = <<-DESC
    GitMarshal is a command-line tool that allows developers to fetch and display various metrics
    about GitHub repositories. It provides insights into issues, stargazers, forks, commits,
    pull requests, and more.
  DESC
  spec.homepage      = "https://github.com/nagstler/gitmarshal"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com/nagstler/gitmarshal"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.glob("{bin,lib}/**/*") + ["gitmarshal.gemspec", "README.md"]
  spec.bindir = "exe"
  spec.executables = ["gitmarshal"]
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "thor", "~> 1.1"
  spec.add_dependency "terminal-table", "~> 3.0.0"
  spec.add_dependency "colorize"
  spec.add_dependency "octokit"
  spec.add_dependency "faraday-retry"

  # Add any additional dependencies required by your gem

  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem,
  # check out our guide at: https://bundler.io/guides/creating_gem.html
end
