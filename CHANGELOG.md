# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.3.0] - 2023-08-01
#### Added 
- New `-ch` option for `gitmarshal repo-name` command: With this new option, users can now display the commit history grouped by days for a given repository. This makes it easier to understand the commit frequency and patterns over time for a repository.

#### Changed
- Refined the way options are displayed in help menu: The help menu now includes a separate "Options" column for better clarity. This allows users to easily understand what options are available for each command and how to use them effectively.

## [1.2.0] - 2023-07-28
#### Updated
- Minor updates to the README for better readability.

## [1.1.0] - 2023-07-24
#### Added
- Introduced the 'Today' option that shows metrics for a repository for the current day.

#### Updated
- Revised and enhanced the README document with appropriate explanations.

#### Fixed
- Carried out code formatting for improved readability and maintenance.

## [1.0.0] - 2023-07-09
### Added
- Added functionality to fetch and display detailed metrics for individual repositories.
- Introduced post-install message for better user guidance.
- Implemented a comprehensive README for developers and users to understand the usage of GitMarshal better.
- Improved error handling for GitHub API calls.

### Changed
- Refined command structure for ease of use. Users can now simply use `gitmarshal` to fetch and display a summary of their GitHub repositories or `gitmarshal <repo-name>` to fetch and display metrics for a specific repository.
- Updated gemspec for production release.

### Removed
- Removed redundant code and dependencies for cleaner, faster performance.

## [0.2.0] - 2023-06-30
### Added
- Basic functionality for fetching and displaying GitHub repository metrics.

## [0.1.0] - 2023-06-28
### Added
- Initial project setup and dependencies.

