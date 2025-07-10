# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.4] - 2025-07-10

### Fixed

- Ensure Hex is loaded to avoid runtime issues

## [0.3.3] - 2025-07-10

### Changed

- Improved documentation
- Drop Igniter from deps, add Credo

## [0.3.2] - 2025-07-09

### Added

- Better status reporting

### Changed

- Enhanced documentation with improved alias examples

## [0.3.1] - 2025-07-09

### Added

- Error handling and logging

## [0.3.0] - 2025-07-09

### Added
- Universal wrapper functionality for Mix tasks
- Support for `--all` flag in dependency operations
- Comprehensive test suite with fixtures
- Development environment setup with devenv and Nix
- Elixir 1.18 compatibility option
- Project documentation and CLAUDE.md integration

### Changed
- Improved output formatting for changelog entries
- Enhanced test coverage and reliability
- Polished codebase with better error handling
- Updated dependency management approach

### Fixed
- Resolved issues with changelog processing
- Fixed test stability and execution
- Improved handling of edge cases in dependency updates

## [0.2.0] - 2025-07-08

### Added
- Basic changelog tracking functionality
- Integration with Igniter for dependency management
- Conditional writing (no updates = no write)
- Code loading checks for Igniter availability

### Changed
- Refined core processing logic
- Better documentation structure

## [0.1.0] - 2025-07-07

### Added
- First prototype implementation
- Core Mix task structure
- Basic dependency changelog aggregation
- Initial project setup and configuration

[0.3.0]: https://github.com/user/deps_changelog/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/user/deps_changelog/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/user/deps_changelog/releases/tag/v0.1.0
