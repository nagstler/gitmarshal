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
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nagstler/gitmarshal"
  spec.metadata["changelog_uri"] = "https://github.com/nagstler/gitmarshal/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{bin,lib}/**/*", File::FNM_DOTMATCH) + ["gitmarshal.gemspec", "README.md"]
  spec.bindir = "bin"
  spec.executables = ["gitmarshal"]
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "thor", "~> 1.1"
  spec.add_dependency "terminal-table", "~> 3.0.0"
  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'

  # Development Dependencies
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop", "~> 1.22"
  
  spec.post_install_message = <<-MSG

#################################################################
##############           GITMARSHAL            ##################
#################################################################

Thank you for installing GitMarshal!

GitMarshal is a command-line tool that allows developers to fetch and display various metrics about GitHub repositories.

In order to use GitMarshal, you need to set up your GitHub access token. Please follow the instructions provided in the README at:

https://github.com/nagstler/gitmarshal#configuration

Enjoy using GitMarshal!

#################################################################

MSG

end
