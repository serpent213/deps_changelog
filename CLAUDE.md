# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ChangelogIgniter is an Elixir Mix task tool that automatically tracks and aggregates changes from dependency changelogs when updating packages. It acts as a wrapper around other Mix tasks (like `igniter.upgrade` or `deps.update`), capturing before/after states of dependency changelogs and generating a consolidated `deps.CHANGELOG.md` file.

## Technology Stack

- **Language**: Elixir (~> 1.16)
- **Build System**: Mix (Elixir's build tool)  
- **Development Environment**: Nix with devenv for reproducible development
- **Testing**: ExUnit (Elixir's built-in testing framework)

## Common Development Commands

### Basic Development
```bash
# Install dependencies
mix deps.get

# Run tests
mix test

# Run specific test file
mix test test/specific_test.exs

# Run tests with verbose output
mix test --trace
```

### Main Usage
```bash
# Primary usage pattern (via configured alias)
mix update

# Direct command
mix deps.changelog igniter.upgrade --all

# Manual mode (for testing/debugging)
mix deps.changelog --before
mix deps.unlock package_name
mix deps.get  
mix deps.changelog --after
```

### Development Environment
```bash
# Enter development shell (if using Nix)
devenv shell

# Update devenv lockfile
devenv update
```

## Architecture Overview

### Core Components

- **`lib/deps_changelog.ex`**: Main module (currently minimal stub)
- **`lib/mix/tasks/deps.changelog.ex`**: Core Mix task implementation containing all logic
- **`test/fixtures/`**: Test fixtures with before/after dependency states for integration testing

### Key Design Patterns

1. **Mix Task Pattern**: Follows Elixir convention for command-line tools
2. **Wrapper Pattern**: Intercepts other Mix tasks to capture changelog changes
3. **Snapshot Pattern**: Uses binary serialization to capture dependency states via `--before`/`--after` flags
4. **Data Structure**: `Changelogs` struct with `@enforce_keys` for required fields

### Processing Pipeline

1. **Capture**: Read changelogs from `deps/*/CHANGELOG.md` or `deps/*/CHANGELOG`
2. **Execute**: Run wrapped task (e.g., `igniter.upgrade`)
3. **Diff**: Compare before/after changelog states using Myers algorithm
4. **Transform**: Shift markdown headings (+2 levels), limit whitespace, format with package name/version
5. **Accumulate**: Insert into `deps.CHANGELOG.md` with date headers

## Testing Strategy

### Test Structure
- Tests are **synchronous** (`async: false`) due to file system race conditions
- Uses `@tag :tmp_dir` for isolated test environments
- Fixture-based testing with before/after dependency states in `test/fixtures/`
- Fixed timestamps for reproducible output

### Test Patterns
```elixir
# Typical test structure
test "description", %{tmp_dir: tmp_dir} do
  # Setup in temporary directory
  # Execute functionality
  # Assert expected outcomes
end
```

## Important Implementation Details

### File Operations
- Changelog detection: Looks for `CHANGELOG.md` or `CHANGELOG` (case-insensitive)
- Output file: Always `deps.CHANGELOG.md` in project root
- Snapshot storage: Uses binary serialization with `:erlang.term_to_binary/1`

### Markdown Processing
- Shifts heading levels by +2 (## becomes ####)
- Limits vertical whitespace to maximum 2 consecutive newlines
- Preserves original formatting while normalizing structure

### Dependencies
- **Runtime**: None (pure Elixir)
- **Development**: Only `igniter` for development/testing
- **Filters**: Only processes top-level dependencies to avoid transitive noise

## Current State

This is a **prototype** project currently in active development. Key areas marked in TODO.md:
- Integration tests using Igniter.Project
- Configuration via mix.exs  
- Documentation
- GitHub CI/CD
- Hex package publishing

## Development Notes

- The project uses `devenv` for reproducible development environments
- All core functionality is concentrated in the Mix task module
- The main module (`lib/deps_changelog.ex`) is currently a stub for future API expansion
- Test fixtures capture real dependency states for comprehensive integration testing