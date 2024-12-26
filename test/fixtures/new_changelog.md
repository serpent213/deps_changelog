# Dependencies Change Log

Auto-updated by `deps_changelog`. 💪

Feel free to edit this file by hand. Updates will be inserted below the following marker:

<!-- changelog -->

_26. December 2024_
-------------------

### `ash` (3.4.45 ➞ 3.4.49)

#### [v3.4.49](https://github.com/ash-project/ash/compare/v3.4.48...v3.4.49) (2024-12-22)


##### Improvements:

- [read actions] - add support for `strict?` in `Ash.read` options. (#1669)

##### Bug Fixes:

* [`Ash.Policy.Authorizer`] ensure that old config applies all aggregate policies

If you've upgraded to the following configuration this does not affect you:

```elixir
config :ash, :policies, no_filter_static_forbidden_reads?: false
```

You should upgrade regardless, and adopt that new configuration.

#### [v3.4.48](https://github.com/ash-project/ash/compare/v3.4.47...v3.4.48) (2024-12-20)

##### Bug Fixes:

- [calculations] properly update sort calculation expressions

- [`Ash.Type.Module`] handle nil values in `Ash.Type.Module`

- [`Ash.Resource`] ensure that `select_by_default?` is honored on loads

- [`Ash.Type.Union`] Verify union types constraint on init

- [loading data] ensure tenant is set on reselection query

##### Improvements:

- [Igniter] handle igniter not being compiled, and make it optional

- [`Ash.Generator`] add `Ash.Generator.next_in_sequence/3`

- [performance] don't reselect unnecessary attributes

- [pagination] add `show_keysets_for_all_actions?` configuration

  Set `config :ash, show_keysets_for_all_actions?, false` for significant performance
  improvements when reading resources that support keyset pagination. This causes
  keysets to only be shown for actions that are actively being paginated with
  keyset pagination.

#### [v3.4.47](https://github.com/ash-project/ash/compare/v3.4.46...v3.4.47) (2024-12-17)

##### Bug Fixes:

- [`Ash.Query`] handle indexed maps and string keys in calculation arguments

- [`Ash.Changeset`] throw validation error when trying to set public arguments in private_arguments (#1663)

- [`Ash.Policy.Authorizer`] include `changeset` in preflight authorization context

- [embedded resources] include presence of authorizers in embedded resource optimization

- [`Ash.DataLayer`] don't check data layer compatibility for manual actions

##### Improvements:

- [`Ash.Reactor`]: Always add the notication middleware any time the extension is added. (#1657)

#### [v3.4.46](https://github.com/ash-project/ash/compare/v3.4.45...v3.4.46) (2024-12-12)

##### Bug Fixes:

- [`Ash.Tracer`] use proper telemetry name for actions

- [`Ash.Sort`] use atoms for paths in related sorts


### `phoenix` (1.7.16 ➞ 1.7.18)

#### 1.7.18 (2024-12-10)

##### Enhancements
  * Use new interpolation syntax in generators
  * Update gettext in generators to 0.26

#### 1.7.17 (2024-12-03)

##### Enhancements
  * Use LiveView 1.0.0 for newly generated applications
