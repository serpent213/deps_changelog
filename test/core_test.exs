defmodule CoreTest do
  # async tests produce a race condition when run in parallel...?
  use ExUnit.Case, async: false

  @fixture_date {{2024, 12, 26}, {18, 21, 16}}

  @tag :tmp_dir
  test "creates changelog", %{tmp_dir: tmp_dir} do
    home = File.cwd!()
    on_exit(fn -> File.cd!(home) end)
    File.cp_r!("test/fixtures/before", tmp_dir)
    File.cd!(tmp_dir)
    deps = Fixtures.MixDeps.deps()

    changelogs = Mix.Tasks.Deps.Changelog.before_update(deps)

    File.cp_r!("#{home}/test/fixtures/after/deps/ash", "deps/ash/")
    File.cp_r!("#{home}/test/fixtures/after/deps/phoenix", "deps/phoenix/")

    dep_changes = [
      {:ash, %Version{major: 3, minor: 4, patch: 45}, %Version{major: 3, minor: 4, patch: 49}},
      {:phoenix, %Version{major: 1, minor: 7, patch: 16}, %Version{major: 1, minor: 7, patch: 18}}
    ]

    Mix.Tasks.Deps.Changelog.after_update(changelogs, dep_changes, @fixture_date)

    deps_changelog = File.read!("deps.CHANGELOG.md")
    expected_deps_changelog = File.read!("#{home}/test/fixtures/new_changelog.md")
    assert deps_changelog == expected_deps_changelog
  end

  @tag :tmp_dir
  test "updates changelog", %{tmp_dir: tmp_dir} do
    home = File.cwd!()
    on_exit(fn -> File.cd!(home) end)
    File.cp_r!("test/fixtures/before", tmp_dir)
    File.cp!("test/fixtures/new_changelog.md", "#{tmp_dir}/deps.CHANGELOG.md")
    File.cd!(tmp_dir)
    deps = Fixtures.MixDeps.deps()

    changelogs = Mix.Tasks.Deps.Changelog.before_update(deps)

    File.cp_r!("#{home}/test/fixtures/after/deps/money", "deps/money/")

    dep_changes = [
      {:money, %Version{major: 1, minor: 13, patch: 0}, %Version{major: 1, minor: 13, patch: 1}}
    ]

    Mix.Tasks.Deps.Changelog.after_update(changelogs, dep_changes, @fixture_date)

    deps_changelog = File.read!("deps.CHANGELOG.md")
    expected_deps_changelog = File.read!("#{home}/test/fixtures/updated_changelog.md")
    assert deps_changelog == expected_deps_changelog
  end

  test "handles dependencies with :compile status" do
    # Test the scenario where dep.status is :compile instead of {:ok, version}
    # This should extract version from the lock info instead
    dep_with_compile_status = %Mix.Dep{
      app: :test_dep,
      status: :compile,
      opts: [
        lock: {:hex, :test_dep, "1.2.3", "hash123", [:mix], [], "hexpm", "checksum456"}
      ],
      top_level: true
    }

    dep_with_ok_status = %Mix.Dep{
      app: :test_dep,
      status: {:ok, "1.0.0"},
      opts: [
        lock: {:hex, :test_dep, "1.0.0", "oldhash", [:mix], [], "hexpm", "oldchecksum"}
      ],
      top_level: true
    }

    old_deps = [dep_with_ok_status]
    new_deps = [dep_with_compile_status]

    # This should not crash and should detect the version change from 1.0.0 to 1.2.3
    changes = Mix.Tasks.Deps.Changelog.dep_changes_in_order(old_deps, new_deps)
    
    assert length(changes) == 1
    {app, old_version, new_version} = hd(changes)
    assert app == :test_dep
    assert old_version == %Version{major: 1, minor: 0, patch: 0}
    assert new_version == %Version{major: 1, minor: 2, patch: 3}
  end

  test "handles dependencies when both old and new have :compile status" do
    # Test when both old and new deps have :compile status
    old_dep = %Mix.Dep{
      app: :both_compile,
      status: :compile,
      opts: [
        lock: {:hex, :both_compile, "2.0.0", "oldhash", [:mix], [], "hexpm", "oldchecksum"}
      ],
      top_level: true
    }

    new_dep = %Mix.Dep{
      app: :both_compile,
      status: :compile,
      opts: [
        lock: {:hex, :both_compile, "2.1.0", "newhash", [:mix], [], "hexpm", "newchecksum"}
      ],
      top_level: true
    }

    changes = Mix.Tasks.Deps.Changelog.dep_changes_in_order([old_dep], [new_dep])
    
    assert length(changes) == 1
    {app, old_version, new_version} = hd(changes)
    assert app == :both_compile
    assert old_version == %Version{major: 2, minor: 0, patch: 0}
    assert new_version == %Version{major: 2, minor: 1, patch: 0}
  end
end
