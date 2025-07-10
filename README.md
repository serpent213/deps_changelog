# deps.changelog

Find additions to top-level dependency's CHANGELOG files upon update and accumulate them in a new
`deps.CHANGELOG.md`. Any task can be specified to run to perform the update.

## Installation

The package is [available in Hex](https://hex.pm/packages/deps_changelog) and can be installed by adding
`deps_changelog` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:deps_changelog, "~> 0.3", only: :dev, runtime: false}
  ]
end
```

## Usage

Run `mix deps.changelog deps.update [...]` instead of `mix deps.update`. File `deps.CHANGELOG.md` will be created
or updated when package updates happen.

### Aliases

When using [Igniter](https://hexdocs.pm/igniter/), you could add to your `mix.exs`:

```elixir
  defp aliases do
    [
      update: [
        # Isolated processes/Mix runners seem to work best when shuffling deps
        "cmd mix deps.changelog --before",
        "cmd mix deps.update igniter",
        "cmd mix igniter.upgrade --all",
        "cmd mix deps.changelog --after",
        fn _args ->
          Mix.shell().info(
            "Run `mix igniter.apply_upgrades igniter:old_version:new_version` to finish igniter update!"
          )
        end
      ]
    ]
  end
```

Note that you might need to `Mix.Task.reenable("deps.changelog")` when bundling tasks within a single Mix session.

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
be found at <https://hexdocs.pm/deps_changelog>.
-->
