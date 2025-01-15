defmodule OldTest do
  use ExUnit.Case, async: false

  @fixture_date {{2024, 12, 26}, {18, 21, 16}}

  @tag :tmp_dir
  test "creates changelog (old)", %{tmp_dir: tmp_dir} do
    home = File.cwd!()
    on_exit(fn -> File.cd!(home) end)
    File.cp_r!("test/fixtures/before", tmp_dir)
    File.cd!(tmp_dir)
    Mix.shell().info("OldTest working dir: #{File.cwd!()}")
    deps = Fixtures.MixDeps.deps()

    changelogs = Mix.Tasks.Igniter.ChangelogUpgrade.cl_before_update(deps)

    File.cp_r!("#{home}/test/fixtures/after/deps/ash", "deps/ash/")
    File.cp_r!("#{home}/test/fixtures/after/deps/phoenix", "deps/phoenix/")

    dep_changes = [
      {:ash, %Version{major: 3, minor: 4, patch: 45}, %Version{major: 3, minor: 4, patch: 49}},
      {:phoenix, %Version{major: 1, minor: 7, patch: 16}, %Version{major: 1, minor: 7, patch: 18}}
    ]

    Mix.Tasks.Igniter.ChangelogUpgrade.cl_after_update(changelogs, dep_changes, @fixture_date)

    deps_changelog = File.read!("deps.CHANGELOG.md")
    expected_deps_changelog = File.read!("#{home}/test/fixtures/new_changelog.md")
    assert deps_changelog == expected_deps_changelog
  end

  @tag :tmp_dir
  test "updates changelog (old)", %{tmp_dir: tmp_dir} do
    home = File.cwd!()
    on_exit(fn -> File.cd!(home) end)
    File.cp_r!("test/fixtures/before", tmp_dir)
    File.cp!("test/fixtures/new_changelog.md", "#{tmp_dir}/deps.CHANGELOG.md")
    File.cd!(tmp_dir)
    Mix.shell().info("OldTest working dir: #{File.cwd!()}")
    deps = Fixtures.MixDeps.deps()

    changelogs = Mix.Tasks.Igniter.ChangelogUpgrade.cl_before_update(deps)

    File.cp_r!("#{home}/test/fixtures/after/deps/money", "deps/money/")

    dep_changes = [
      {:money, %Version{major: 1, minor: 13, patch: 0}, %Version{major: 1, minor: 13, patch: 1}}
    ]

    Mix.Tasks.Igniter.ChangelogUpgrade.cl_after_update(changelogs, dep_changes, @fixture_date)

    deps_changelog = File.read!("deps.CHANGELOG.md")
    expected_deps_changelog = File.read!("#{home}/test/fixtures/updated_changelog.md")
    assert deps_changelog == expected_deps_changelog
  end
end
