# frozen_string_literal: true

require_relative "lib/gitmarshal/version"

Gem::Specification.new do |spec|
  spec.name = "gitmarshal"
  spec.version = Gitmarshal::VERSION
  spec.authors = ["Nagendra Dhanakeerthi"]
  spec.email = ["nagendra.dhanakeerthi@gmail.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/nagstler/gitmarshal"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com/nagstler/gitmarshal"

  spec.metadata["homepage_uri"] = "https://github.com/nagstler/gitmarshal"
  spec.metadata["source_code_uri"] = "https://github.com/nagstler/gitmarshal"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'json', '~> 2.5'
  spec.add_dependency 'rest-client', '~> 2.1'
  spec.add_dependency 'dotenv', '~> 2.7'
  spec.add_dependency 'thor', '~> 1.1'
  spec.add_dependency 'terminal-table', '~> 3.0.0'
  spec.add_dependency 'colorize'


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
