# Dependencies Change Log

Auto-updated by `deps_changelog`. 💪

Feel free to edit this file by hand. Updates will be inserted below the following marker:

<!-- changelog -->

_9. July 2025_
--------------

### `igniter` (0.5.0 ➞ 0.6.12)

#### [v0.6.12](https://github.com/ash-project/igniter/compare/v0.6.11...v0.6.12) (2025-07-09)


##### Bug Fixes:

* properly encode values added to mix project by Zach Daniel

#### [v0.6.11](https://github.com/ash-project/igniter/compare/v0.6.10...v0.6.11) (2025-07-06)


##### Improvements:

* when stdin is not a tyy, treat that as --yes by Zach Daniel

#### [v0.6.10](https://github.com/ash-project/igniter/compare/v0.6.9...v0.6.10) (2025-07-02)


##### Improvements:

* make `Igniter.exists?` support directories by Zach Daniel

#### [v0.6.9](https://github.com/ash-project/igniter/compare/v0.6.8...v0.6.9) (2025-06-25)


##### Improvements:

* Implement removal of configuration (#309) by Benjamin Milde

* add `required?` option to `Igniter.update_elixir_file/3` by Benjamin Milde

#### [v0.6.8](https://github.com/ash-project/igniter/compare/v0.6.7...v0.6.8) (2025-06-18)


##### Bug Fixes:

* properly honor explicitly passed --only flag over other `only` configs by Zach Daniel

* properly render the child that must be placed in the supervision tree by Zach Daniel

##### Improvements:

* Update argument error message about apply_igniter in test (#305) by Kenneth Kostrešević

#### [v0.6.7](https://github.com/ash-project/igniter/compare/v0.6.6...v0.6.7) (2025-06-08)


##### Bug Fixes:

* In assert_has_issue/3 set condition with issue as function #297 (#298)

##### Improvements:

* fix issue w/ type system validation on old versions of elixir

* support private repositories

* Use hex to support looking up org package versions (#299)

* Add missing --only flag documentation for installer install task (#284)

* add `refute_creates`

#### [v0.6.6](https://github.com/ash-project/igniter/compare/v0.6.5...v0.6.6) (2025-06-06)


##### Improvements:

* remove protocol consolidation dev changes

* add `Igniter.rm` and track removed files across operations

#### [v0.6.5](https://github.com/ash-project/igniter/compare/v0.6.4...v0.6.5) (2025-06-04)


##### Bug Fixes:

* properly rename function & attributes on module move

#### [v0.6.4](https://github.com/ash-project/igniter/compare/v0.6.3...v0.6.4) (2025-05-30)


##### Bug Fixes:

* reword syntax to avoid compile error

##### Improvements:

* introduce `Igniter.Scribe` and `--scribe` option

#### [v0.6.3](https://github.com/ash-project/igniter/compare/v0.6.2...v0.6.3) (2025-05-29)


##### Bug Fixes:

* display all error output, and bump installer version

* Display notices even when there are no content changes.

#### [v0.6.2](https://github.com/ash-project/igniter/compare/v0.6.1...v0.6.2) (2025-05-24)


##### Improvements:

* track task name and parent task name in igniter

* add `quiet_on_no_changes?` assign

* add usage-rules.md

#### [v0.6.1](https://github.com/ash-project/igniter/compare/v0.6.0...v0.6.1) (2025-05-22)


##### Bug Fixes:

* remove references to old versions

#### [v0.6.0](https://github.com/ash-project/igniter/compare/v0.5.52...v0.6.0) (2025-05-21)


##### Bug Fixes:

* OTP 28 Compatibility via removing inflex (#288)

Use `Igniter.Inflex.pluralize` or depend on `Inflex` directly if you need it

#### [v0.5.52](https://github.com/ash-project/igniter/compare/v0.5.51...v0.5.52) (2025-05-20)


##### Improvements:

* bump installer version

* Add igniter.init task to igniter_new archive (#283)

* clean up igniter after adding it for installation

* Task/adds move to function and attrs (#274)

* generate a test when generating a new task

#### [v0.5.51](https://github.com/ash-project/igniter/compare/v0.5.50...v0.5.51) (2025-05-15)


##### Bug Fixes:

* properly detect map format

* don't always create default config files

* Add impl to generated mix task (#276)

* Matches function guards when using move_to_def (#273)

#### [v0.5.50](https://github.com/ash-project/igniter/compare/v0.5.49...v0.5.50) (2025-05-01)


##### Bug Fixes:

* don't try to inspect functions in test helpers

#### [v0.5.49](https://github.com/ash-project/igniter/compare/v0.5.48...v0.5.49) (2025-04-30)


##### Improvements:

* properly honor `--only` flag

#### [v0.5.48](https://github.com/ash-project/igniter/compare/v0.5.47...v0.5.48) (2025-04-29)


##### Improvements:

* clean up `igniter/1-2` check, and make it a warning

#### [v0.5.47](https://github.com/ash-project/igniter/compare/v0.5.46...v0.5.47) (2025-04-21)


##### Improvements:

* make router optional in `select_endpoint`

* accept functions in warning/notice/issue assertions

* add `Igniter.Code.Common.variable?`

#### [v0.5.46](https://github.com/ash-project/igniter/compare/v0.5.45...v0.5.46) (2025-04-15)


##### Bug Fixes:

* wording in router selection message

#### [v0.5.45](https://github.com/ash-project/igniter/compare/v0.5.44...v0.5.45) (2025-04-10)


##### Bug Fixes:

* keep as close to installer order as possible for dependencies

#### [v0.5.44](https://github.com/ash-project/igniter/compare/v0.5.43...v0.5.44) (2025-04-09)


##### Bug Fixes:

* handle list of arities in `Igniter.Code.Function.function_call?/3`

##### Improvements:

* install private packages from hexpm (#157)

* prevent infinitely looping install task

#### [v0.5.43](https://github.com/ash-project/igniter/compare/v0.5.42...v0.5.43) (2025-04-02)


##### Bug Fixes:

* properly use `dep_opts` when comparing new deps

#### [v0.5.42](https://github.com/ash-project/igniter/compare/v0.5.41...v0.5.42) (2025-03-31)


##### Improvements:

* add live_debugger to our known only env config

#### [v0.5.41](https://github.com/ash-project/igniter/compare/v0.5.40...v0.6.0) (2025-03-28)


##### Features:

* add igniter.add task (#258)

##### Improvements:

* show warning about generating new umbrella projects

#### [v0.5.40](https://github.com/ash-project/igniter/compare/v0.5.39...v0.5.40) (2025-03-26)


##### Bug Fixes:

* only display changing sources in `puts_diff` in test

##### Improvements:

* more testing helpers

* support error/warning/notice returns on updating files

#### [v0.5.39](https://github.com/ash-project/igniter/compare/v0.5.38...v0.5.39) (2025-03-25)


##### Bug Fixes:

* handler erlang style modules in function detection

* igniter.upgrade crash on dependency declaration when only option is an atom (#257)

##### Improvements:

* add `Igniter.Code.Common.add_comment/2`

* add `Igniter.Project.Config.configure_group/6`

#### [v0.5.38](https://github.com/ash-project/igniter/compare/v0.5.37...v0.5.38) (2025-03-21)


##### Bug Fixes:

* handler erlang style modules in function detection

#### [v0.5.37](https://github.com/ash-project/igniter/compare/v0.5.36...v0.5.37) (2025-03-18)


##### Improvements:

* avoid duplicate module warning on local.igniter

#### [v0.5.36](https://github.com/ash-project/igniter/compare/v0.5.35...v0.5.36) (2025-03-14)


##### Bug Fixes:

* add in an ugly hack for handling common packages `only` option

#### [v0.5.35](https://github.com/ash-project/igniter/compare/v0.5.34...v0.5.35) (2025-03-12)


##### Bug Fixes:

* don't use `Application.app_dir` as the app may not be running yet

#### [v0.5.34](https://github.com/ash-project/igniter/compare/v0.5.33...v0.5.34) (2025-03-12)


##### Bug Fixes:

* ensure composed installers happen first

#### [v0.5.33](https://github.com/ash-project/igniter/compare/v0.5.32...v0.5.33) (2025-03-11)


##### Bug Fixes:

* add backwards compatibility function for relative_to_cwd

* trim package install list to handle edge case

* installer: handle `--with-args="string"` syntax

##### Improvements:

* Add `:placement` option to `Phoenix.add_scope/4` and `Phoenix.append_to_scope/4` (#251)

* add `mix igniter.remove dep1 dep2` task

* add `assert_has_task` test helper

#### [v0.5.32](https://github.com/ash-project/igniter/compare/v0.5.31...v0.5.32) (2025-03-08)


##### Bug Fixes:

* properly replace `_` with `-` in task group names

#### [v0.5.31](https://github.com/ash-project/igniter/compare/v0.5.30...v0.5.31) (2025-03-04)


#### [v0.5.30](https://github.com/ash-project/igniter/compare/v0.5.29...v0.5.30) (2025-03-03)


##### Bug Fixes:

* various fixes with cross project function renaming

* ensure all paths are relative_to_cwd

##### Improvements:

* mix igniter.refactor.rename_function short doc (#243)

* add `local.igniter` task for easier upgrading

#### [v0.5.29](https://github.com/ash-project/igniter/compare/v0.5.28...v0.5.29) (2025-02-25)


##### Bug Fixes:

* remove erroneous diff displaying code

#### [v0.5.28](https://github.com/ash-project/igniter/compare/v0.5.27...v0.5.28) (2025-02-24)


##### Improvements:

* add phx_test_project for testing(#239)

#### [v0.5.27](https://github.com/ash-project/igniter/compare/v0.5.26...v0.5.27) (2025-02-20)


##### Improvements:

* support dep_opts in schema info

#### [v0.5.26](https://github.com/ash-project/igniter/compare/v0.5.25...v0.5.26) (2025-02-20)


##### Bug Fixes:

* only look for .formatter.exs files in known directories

* load all known archives when running the archive installer

#### [v0.5.25](https://github.com/ash-project/igniter/compare/v0.5.24...v0.5.25) (2025-02-16)


##### Bug Fixes:

* check file changed by actually comparing content

* pattern match error when default option is selected on long diff

#### [v0.5.24](https://github.com/ash-project/igniter/compare/v0.5.23...v0.5.24) (2025-02-12)


##### Bug Fixes:

* resolve project :config_path (#226)

#### [v0.5.23](https://github.com/ash-project/igniter/compare/v0.5.22...v0.5.23) (2025-02-11)


##### Bug Fixes:

* better error messages and fixes for unconventional deps

#### [v0.5.22](https://github.com/ash-project/igniter/compare/v0.5.21...v0.5.22) (2025-02-11)


##### Bug Fixes:

* fix & simplify keyword removal

* don't pass --from-elixir-install in with-args by default

* `web_module/1` duplicating Web (#221)

* ensure that installer includes apps igniter needs

* properly split --with-args

##### Improvements:

* support non-literal/non-standard deps lists

* better UX around large files (#222)

* Change default updater fn for configure_runtime_env/6 to match configure/6 (#220)

#### [v0.5.21](https://github.com/ash-project/igniter/compare/v0.5.20...v0.5.21) (2025-02-03)


##### Bug Fixes:

* error in codemod while formatting

##### Improvements:

* Add `:after` opt to `Config` functions (#213)

* make diff checking faster

#### [v0.5.20](https://github.com/ash-project/igniter/compare/v0.5.19...v0.5.20) (2025-01-27)


##### Improvements:

* raise when installing igniter as an archive

#### [v0.5.19](https://github.com/ash-project/igniter/compare/v0.5.18...v0.5.19) (2025-01-27)


##### Features:

* `Igniter.Code.Module.move_to_attribute_definition` (#207)

##### Bug Fixes:

* handle single length list config paths that already exist

#### [v0.5.18](https://github.com/ash-project/igniter/compare/v0.5.17...v0.5.18) (2025-01-27)


##### Improvements:

* show yellow text indicating generated notices

#### [v0.5.17](https://github.com/ash-project/igniter/compare/v0.5.16...v0.5.17) (2025-01-26)


##### Improvements:

* remove warnings about `Phx.New` in some new projects

* properly parse with_args in igniter.new

#### [v0.5.16](https://github.com/ash-project/igniter/compare/v0.5.15...v0.5.16) (2025-01-22)


##### Improvements:

* add owl/inflex utility dependencies

#### [v0.5.15](https://github.com/ash-project/igniter/compare/v0.5.14...v0.5.15) (2025-01-22)


##### Improvements:

* protect against csv errors on windows

#### [v0.5.14](https://github.com/ash-project/igniter/compare/v0.5.13...v0.5.14) (2025-01-21)


##### Bug Fixes:

* ensure only relative paths are added to rewrite

#### [v0.5.13](https://github.com/ash-project/igniter/compare/v0.5.12...v0.5.13) (2025-01-21)


##### Bug Fixes:

* handle local igniter in installer w/ more granular deps compile

#### [v0.5.12](https://github.com/ash-project/igniter/compare/v0.5.11...v0.5.12) (2025-01-20)


##### Bug Fixes:

* don't run `deps.compile` task after `deps.get`

##### Improvements:

* use `req` instead of httpc for calling to hex

* shorter package install line

#### [v0.5.11](https://github.com/ash-project/igniter/compare/v0.5.10...v0.5.11) (2025-01-20)


##### Bug Fixes:

* don't assume path for application module

#### [v0.5.10](https://github.com/ash-project/igniter/compare/v0.5.9...v0.5.10) (2025-01-20)


##### Bug Fixes:

* fix duplication of comments on dep writing in empty project

#### [v0.5.9](https://github.com/ash-project/igniter/compare/v0.5.8...v0.5.9) (2025-01-19)


##### Bug Fixes:

* combine comments when adding or replacing code

* `Igniter.Project.MixProject.update/4` now creates non-existing functions (#190)

##### Improvements:

* ensure phoenix /live files go where they should

* Default `yes?` to Y (#197)

* Add `Phoenix.select_endpoint/3` (#192)

#### [v0.5.8](https://github.com/ash-project/igniter/compare/v0.5.7...v0.5.8) (2025-01-06)


##### Improvements:

* significant cleanup of deps compilation logic

* suppress all output for cleaner loading spinners

#### [v0.5.7](https://github.com/ash-project/igniter/compare/v0.5.6...v0.5.7) (2025-01-06)


##### Bug Fixes:

* properly iterate over tasks list

#### [v0.5.6](https://github.com/ash-project/igniter/compare/v0.5.5...v0.5.6) (2025-01-05)


##### Improvements:

* better step explanation in installer

#### [v0.5.5](https://github.com/ash-project/igniter/compare/v0.5.4...v0.5.5) (2025-01-05)


##### Bug Fixes:

* only display mix.exs changes when showing them

#### [v0.5.4](https://github.com/ash-project/igniter/compare/v0.5.3...v0.5.4) (2025-01-05)


##### Bug Fixes:

* don't show git warning for changes igniter made

* print message after diff

* allow check to pass when no issues found (#178)

##### Improvements:

* capture and suppress output in installers (#186)

* print version diff when upgrading packages (#185)

* sort the `missing` packages when upgrading

#### [v0.5.3](https://github.com/ash-project/igniter/compare/v0.5.2...v0.5.3) (2024-12-26)


##### Bug Fixes:

* ensure deps are compiled and proceed w/ install if igniter is

##### Improvements:

* rip out shared utils

#### [v0.5.2](https://github.com/ash-project/igniter/compare/v0.5.1...v0.5.2) (2024-12-25)


##### Improvements:

* add `--yes-to-deps` option to `mix igniter.install`

* add `--yes-to-deps` when using `mix igniter.new`

#### [v0.5.1](https://github.com/ash-project/igniter/compare/v0.5.0...v0.5.1) (2024-12-24)


##### Bug Fixes:

* Igniter.mkdir not expanding paths correctly (#174)

* handle case where third tuple elem is nil

* handle mix rebar deprecations for 1.18 (#172)

##### Improvements:

* add `prepend_to_pipeline` and `has_pipeline` to

* add fallback igniter install in archive

- move project related things to `Project` namespace


