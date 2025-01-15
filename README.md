# ChangelogIgniter

**PROTOTYPE!**

Find additions to dependency's CHANGELOG files upon update and accumulate them in
a new `deps.CHANGELOG.md`.

## Installation

If not [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `changelog_igniter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:changelog_igniter,
      git: "https://github.com/serpent213/changelog_igniter.git",
      branch: "master",
      only: :dev}
  ]
end
```

## Usage

Run `mix deps.changelog igniter.upgrade [...]` instead of `mix igniter.upgrade`. Run `mix
igniter.upgrade` instead of `mix deps.update`. File `deps.CHANGELOG.md` will be created
or updated when package updates happen.

## Debugging

```
$ iex --dbg pry -S mix
iex> break! Mix.Tasks.Deps.Changelog.run/1
iex> break! Mix.Tasks.Deps.Changelog.after_update/2
iex> Mix.Task.run "deps.changelog", ["deps.update", "--all"]
```

<!--
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/changelog_igniter>.
-->
