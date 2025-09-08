defmodule GitDependencyTest do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Deps.Changelog

  describe "Git dependency version handling" do
    test "uses commit hash for Git dependencies, not semantic version from status" do
      # Git dependencies report semantic versions in their status field
      # but we should use the commit hash from the lock for comparison
      git_dep = %Mix.Dep{
        app: :my_git_dep,
        top_level: true,
        status: {:ok, "1.0.0"},  # Semantic version from the package's mix.exs
        opts: [
          lock: {:git, "https://github.com/example/repo.git",
                 "abc123def456789012345678901234567890abcd", [ref: "abc123d"]}
        ],
        deps: []
      }
      
      # When comparing the same Git dependency, no changes should be detected
      changes = Changelog.dep_changes_in_order([git_dep], [git_dep])
      
      assert changes == [], 
        "Identical Git dependencies should not be reported as changed"
    end
    
    test "detects actual changes in Git dependencies" do
      old_git_dep = %Mix.Dep{
        app: :my_git_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock: {:git, "https://github.com/example/repo.git",
                 "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }
      
      new_git_dep = %Mix.Dep{
        app: :my_git_dep,
        top_level: true,
        status: {:ok, "1.0.0"},  # Same version in mix.exs
        opts: [
          lock: {:git, "https://github.com/example/repo.git",
                 "def456789012345678901234567890abcdef4567", []}  # Different commit (40 chars)
        ],
        deps: []
      }
      
      changes = Changelog.dep_changes_in_order([old_git_dep], [new_git_dep])
      
      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :my_git_dep
      # 40-char Git hashes are shortened to 8 chars for display
      assert old_v.display == "abc123de"
      assert new_v.display == "def45678"
    end
    
    test "handles transition from Git to hex dependency" do
      git_dep = %Mix.Dep{
        app: :transitioning_dep,
        top_level: true,
        status: {:ok, "abc123def456789012345678901234567890abcd"},
        opts: [
          lock: {:git, "https://github.com/example/repo.git",
                 "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }
      
      hex_dep = %Mix.Dep{
        app: :transitioning_dep,
        top_level: true,
        status: {:ok, "1.2.0"},
        opts: [],  # No lock for hex deps in this format
        deps: []
      }
      
      changes = Changelog.dep_changes_in_order([git_dep], [hex_dep])
      
      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :transitioning_dep
      assert old_v.display == "abc123de"
      assert new_v.display == "1.2.0"
    end
    
    test "handles transition from hex to Git dependency" do
      hex_dep = %Mix.Dep{
        app: :transitioning_dep,
        top_level: true,
        status: {:ok, "1.2.0"},
        opts: [],
        deps: []
      }
      
      git_dep = %Mix.Dep{
        app: :transitioning_dep,
        top_level: true,
        status: {:ok, "1.2.0"},  # Same version but now from Git
        opts: [
          lock: {:git, "https://github.com/example/repo.git",
                 "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }
      
      changes = Changelog.dep_changes_in_order([hex_dep], [git_dep])
      
      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :transitioning_dep
      assert old_v.display == "1.2.0"
      assert new_v.display == "abc123de"
    end
    
    test "multiple unchanged Git dependencies don't show spurious changes" do
      # This tests the bug we found in the Enaia project where
      # multiple Git deps showed as changed when they weren't
      deps = [
        %Mix.Dep{
          app: :git_dep_one,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock: {:git, "https://github.com/example/one.git",
                   "1111111111111111111111111111111111111111", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :git_dep_two,
          top_level: true,
          status: {:ok, "2.0.0"},
          opts: [
            lock: {:git, "https://github.com/example/two.git",
                   "2222222222222222222222222222222222222222", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :git_dep_three,
          top_level: true,
          status: {:ok, "3.0.0"},
          opts: [
            lock: {:git, "https://github.com/example/three.git",
                   "3333333333333333333333333333333333333333", []}
          ],
          deps: []
        }
      ]
      
      # Compare identical deps - should show no changes
      changes = Changelog.dep_changes_in_order(deps, deps)
      
      assert changes == [], 
        "No Git dependencies should be reported as changed when they haven't changed"
    end
  end
end