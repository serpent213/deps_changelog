# ChangelogIgniter

**PROTOTYPE!**

Find additions to dependency's CHANGELOG files upon update and accumulate them in
a new `deps.CHANGELOG.md`. Based on [Igniter](https://github.com/ash-project/igniter).

## Installation

If not [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `changelog_igniter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:changelog_igniter,
      git: "https://github.com/serpent213/changelog_igniter.git",
      ref: "ebc8bf4ab411d27d19b5b21d83d98d7953df80fa",
      only: :dev}
  ]
end
```

## Usage

Run `mix igniter.changelog_upgrade [...]` instead of `mix igniter.upgrade`. Run `mix
igniter.upgrade` instead of `mix deps.update`. File `deps.CHANGELOG.md` will be created
or updated when package updates happen.

<!--
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/changelog_igniter>.
-->
