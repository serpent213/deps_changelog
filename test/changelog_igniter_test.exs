defmodule ChangelogIgniterTest do
  use ExUnit.Case

  describe "changelog functionality" do
    setup do
      File.rm_rf!("test_changelog_project")
      Mix.shell().info("Creating test_changelog_project")
      System.cmd("mix", ["new", "test_changelog_project"])

      on_exit(fn -> File.rm_rf!("test_changelog_project") end)
    end

    @tag :skip
    test "updates packages and records changelog" do
      # Install two packages
      System.cmd("mix", ["igniter.install", "plug@1.8", "--yes"], cd: "test_changelog_project")
      System.cmd("mix", ["igniter.install", "jason@1.2", "--yes"], cd: "test_changelog_project")

      # Simulate bumping versions in mix.exs (just an example)
      mix_exs_path = Path.join("test_changelog_project", "mix.exs")
      contents = File.read!(mix_exs_path)

      updated_contents =
        contents
        |> String.replace("plug@1.8", "plug@1.9")
        |> String.replace("jason@1.2", "jason@1.3")

      File.write!(mix_exs_path, updated_contents)

      # Run the changelog upgrade task
      output =
        System.cmd("mix", ["igniter.changelog_upgrade", "--all"], cd: "test_changelog_project")

      Mix.shell().info("Output: #{elem(output, 0)}")

      changelog_path = Path.join("test_changelog_project", "deps.CHANGELOG.md")
      changelog = File.read!(changelog_path)
      assert changelog =~ "plug@1.9"
      assert changelog =~ "jason@1.3"
    end
  end
end
