# GitMarshal
[![Gem Version](https://badge.fury.io/rb/gitmarshal.svg)](https://badge.fury.io/rb/gitmarshal) [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Maintainability](https://api.codeclimate.com/v1/badges/a9c81f4f449374df1e0c/maintainability)](https://codeclimate.com/github/nagstler/gitmarshal/maintainability) [![CI Build](https://github.com/nagstler/gitmarshal/actions/workflows/gem-push.yml/badge.svg?branch=main)](https://github.com/nagstler/gitmarshal/actions/workflows/gem-push.yml)

GitMarshal is a command-line interface (CLI) to extract and display various statistics about GitHub repositories. The metrics it retrieves include the number of commits, pull requests, issues, stars, and contributors.

Whether you're a developer interested in the activity of a repository or a manager tracking the progress of your project, GitMarshal provides an easy way to fetch this data directly from your command line.

## :sparkles: Features

:octocat: Fetch and display a summary of your GitHub repositories.

:bar_chart: Fetch and display detailed metrics for a specific repository, including number of commits, pull requests, issues, stars, and contributors.

:computer: Easy-to-use command-line interface.

:wrench: Configurable through environment variables.

:gem: Available as a Ruby gem for easy installation.


## Table of Contents 
- [Prerequisites](#prerequisites) 
- [Installation](#installation) 
- [Configuration](#configuration) 
- [Usage](#usage)
- [Development](#development) 
- [Contributing](#contributing) 
- [License](#license)

## Prerequisites
### 1. Verify Ruby Installation

Before installing GitMarshal, ensure Ruby (version 2.5 or later) is installed on your system. Check your Ruby version using:

```bash
ruby -v
```

### 2. Install Ruby (If Not Installed)

If Ruby is not installed or the version is below 2.5, follow the instructions below to install or upgrade Ruby:
#### Ubuntu

```bash
sudo apt-get update
sudo apt-get install ruby-full
```

#### MacOS

```bash
brew install ruby
```

#### Windows

Follow the instructions on the [Ruby Installer download page](https://rubyinstaller.org/downloads/) .
### 3. Generate GitHub Access Token

To use GitMarshal, generate a GitHub access token: 
1. Visit [GitHub Tokens New](https://github.com/settings/tokens/new)
2. Enter a Note (e.g., "For GitMarshal").
3. Check the "repo" option under "Select scopes".
4. Click "Generate token" and save the generated token for configuration.

Now, with Ruby installed and a GitHub token generated, you are ready to install and configure GitMarshal.

## Installation

GitMarshal can be installed directly as a Ruby gem. To do so, simply run the following command in your terminal:

```bash
gem install gitmarshal
```

This command will download and install the GitMarshal gem onto your system.

## Configuration

To use GitMarshal, an environment variable with your GitHub access token needs to be set up. You can do this by adding the following line to your shell profile file (such as `.bashrc`, `.bash_profile`, or `.zshrc`):

```bash
export GITHUB_TOKEN=your_github_token_here
```

Be sure to replace `your_github_token_here` with the token you generated in the Prerequisites step.

## Usage

Once installed and configured, GitMarshal can be used directly from the command-line as follows:

### List All Repositories

To fetch and display a summary of all your GitHub repositories, run:

```bash
gitmarshal
```

This will provide you with a comprehensive list of your repositories and will show the number of issues, stars, and forks for each repository.

### Fetch Metrics for a Specific Repository

To fetch and display overall metrics for a specific repository, use:

```bash
gitmarshal repo-name
```

Replace `repo-name` with the name of the repository for which you wish to fetch metrics. 

### Fetch Today's Metrics for a Specific Repository

To fetch and display metrics for a specific repository for today only, use:

```bash
gitmarshal repo-name --today
```

Replace `repo-name` with the name of the repository for which you wish to fetch today's metrics. 

### Help Command

If you need help with the commands or if you are unsure about the functionality of GitMarshal, use the help command:

```bash
gitmarshal help
```

This will display a helpful guide on how to use GitMarshal, its options, and commands.

## Development

If you'd like to contribute to the development of GitMarshal, first clone the repository and install the dependencies:

```bash
git clone https://github.com/nagstler/gitmarshal.git
cd gitmarshal
bundle install
```

You can then run the tests with:

```bash
rake spec
```

For a more interactive development experience, start a console with:

```bash
bin/console
```

## Contributing

Your contributions to further improve GitMarshal are most welcome. Whether it's reporting a bug or proposing a new feature, you can help enhance this tool. Feel free to create bug reports and pull requests on our GitHub page at [https://github.com/nagstler/gitmarshal](https://github.com/nagstler/gitmarshal) .

We aim to maintain a welcoming and inclusive environment for collaboration, and all contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/)  code of conduct.

## License

GitMarshal is open-source and available under the terms of the [MIT License](https://opensource.org/licenses/MIT) .
