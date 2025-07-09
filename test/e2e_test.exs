defmodule E2eTest do
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
      # Copy the task into the test project
      File.mkdir_p!("test_changelog_project/lib/mix/tasks")

      File.cp!(
        "lib/mix/tasks/deps.changelog.ex",
        "test_changelog_project/lib/mix/tasks/deps.changelog.ex"
      )

      # Add packages to mix.exs
      mix_exs_path = Path.join("test_changelog_project", "mix.exs")
      contents = File.read!(mix_exs_path)

      updated_contents =
        String.replace(
          contents,
          "# {:dep_from_hexpm, \"~> 0.3.0\"},",
          "{:plug, \"~> 1.8.0\"},\n      {:jason, \"~> 1.2.0\"},"
        )

      File.write!(mix_exs_path, updated_contents)

      # Get initial deps
      System.cmd("mix", ~w{deps.get}, cd: "test_changelog_project")

      # Update versions in mix.exs
      contents = File.read!(mix_exs_path)

      updated_contents =
        contents
        |> String.replace("plug\", \"~> 1.8\"", "plug\", \"~> 1.9\"")
        |> String.replace("jason\", \"~> 1.2\"", "jason\", \"~> 1.3\"")

      File.write!(mix_exs_path, updated_contents)

      # Run the changelog upgrade task
      {output, exit_code} =
        System.cmd("mix", ~w{deps.changelog deps.update --all}, cd: "test_changelog_project")

      Mix.shell().info("Output: #{output}")
      Mix.shell().info("Exit code: #{exit_code}")

      changelog_path = Path.join("test_changelog_project", "deps.CHANGELOG.md")

      if File.exists?(changelog_path) do
        changelog = File.read!(changelog_path)
        assert changelog =~ "plug"
      else
        flunk("deps.CHANGELOG.md was not created")
      end
    end
  end
end
