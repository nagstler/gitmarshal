# GitMarshal
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Maintainability](https://api.codeclimate.com/v1/badges/a9c81f4f449374df1e0c/maintainability)](https://codeclimate.com/github/nagstler/gitmarshal/maintainability)

GitMarshal is a command-line application that fetches and displays various metrics about your GitHub repositories. This includes details such as repository number of commits, pull requests, issues, and contributors. 

## Prerequisites

Ensure you have Ruby installed in your system. You can check this by running the following command in your terminal:

```
ruby -v
```

You should see Ruby's version if it's installed.

You also need to generate a GitHub access token. Follow these steps to generate it:
- Visit the following URL: https://github.com/settings/tokens/new
- Enter a Note (can be anything, e.g., "For GitMarshal").
- Under "Select scopes", check the "repo" option.
- Click on "Generate token" at the bottom.

## Installation

Clone this repository to your local system.

```
git clone https://github.com/<your-username>/gitmarshal.git
cd gitmarshal
```

Install the required gems by running the following command:

```
bundle install
```

## Configuration

To configure GitMarshal, you need to provide it with your GitHub access token. 

Create a `.env` file in the project root and add your GitHub token:

```
GITHUB_TOKEN=your_github_token_here
```

## Usage

### List Repositories

To fetch and display a summary of your GitHub repositories, run:

```
./bin/gitmarshal
```

This will display a list of your repositories along with the number of issues, stargazers, and forks for each one.

### Fetch Repository Metrics

To fetch and display metrics for a specific repository, use:

```
./bin/gitmarshal <repo-name>
```

Replace `<repo-name>` with the name of your repository.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nagstler/gitmarshal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nagstler/gitmarshal/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
