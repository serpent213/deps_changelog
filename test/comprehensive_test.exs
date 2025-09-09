defmodule ComprehensiveTest do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Deps.Changelog

  describe "Hex dependency changes" do
    test "detects version change in hex dependency" do
      old_hex = %Mix.Dep{
        app: :phoenix,
        top_level: true,
        status: {:ok, "1.7.0"},
        opts: [
          lock: {:hex, :phoenix, "1.7.0", "abc123", [:mix], [], "hexpm", "checksum"}
        ],
        deps: []
      }

      new_hex = %Mix.Dep{
        app: :phoenix,
        top_level: true,
        status: {:ok, "1.7.1"},
        opts: [
          lock: {:hex, :phoenix, "1.7.1", "def456", [:mix], [], "hexpm", "checksum"}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([old_hex], [new_hex])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :phoenix
      assert old_v.display == "1.7.0"
      assert new_v.display == "1.7.1"
    end

    test "no change detected for identical hex versions" do
      hex_dep = %Mix.Dep{
        app: :phoenix,
        top_level: true,
        status: {:ok, "1.7.0"},
        opts: [
          lock: {:hex, :phoenix, "1.7.0", "abc123", [:mix], [], "hexpm", "checksum"}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([hex_dep], [hex_dep])
      assert changes == []
    end
  end

  describe "Git dependency changes" do
    test "detects commit change in same Git repository" do
      old_git = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        # Version from mix.exs
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }

      new_git = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        # Version changed in mix.exs
        status: {:ok, "1.0.1"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "def456789012345678901234567890abcdef4567", []}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([old_git], [new_git])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :my_dep
      assert old_v.display == "owner/repo@abc123de"
      assert new_v.display == "owner/repo@def45678"
    end

    test "no change for identical Git commits" do
      git_dep = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([git_dep], [git_dep])
      assert changes == []
    end

    test "detects repository change (fork switch)" do
      original_repo = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/original/repo.git",
             "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }

      forked_repo = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock: {
            :git,
            "https://github.com/myfork/repo.git",
            # Same commit, different repo
            "abc123def456789012345678901234567890abcd",
            []
          }
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([original_repo], [forked_repo])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :my_dep
      assert old_v.display == "original/repo@abc123de"
      assert new_v.display == "myfork/repo@abc123de"
    end
  end

  describe "Hex to Git transitions" do
    test "transition from hex to git dependency" do
      hex_dep = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock: {:hex, :my_dep, "1.0.0", "abc123", [:mix], [], "hexpm", "checksum"}
        ],
        deps: []
      }

      git_dep = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        # Same version but from Git
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([hex_dep], [git_dep])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :my_dep
      assert old_v.display == "1.0.0"
      assert new_v.display == "owner/repo@abc123de"
    end

    test "transition from git to hex dependency" do
      git_dep = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", []}
        ],
        deps: []
      }

      hex_dep = %Mix.Dep{
        app: :my_dep,
        top_level: true,
        status: {:ok, "1.0.1"},
        opts: [
          lock: {:hex, :my_dep, "1.0.1", "def456", [:mix], [], "hexpm", "checksum"}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([git_dep], [hex_dep])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :my_dep
      assert old_v.display == "owner/repo@abc123de"
      assert new_v.display == "1.0.1"
    end
  end

  describe "Multiple Git dependencies" do
    test "multiple unchanged Git dependencies show no changes" do
      deps = [
        %Mix.Dep{
          app: :dep_one,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/one.git",
               "1111111111111111111111111111111111111111", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :dep_two,
          top_level: true,
          status: {:ok, "2.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/two.git",
               "2222222222222222222222222222222222222222", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :dep_three,
          top_level: true,
          status: {:ok, "3.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/three.git",
               "3333333333333333333333333333333333333333", []}
          ],
          deps: []
        }
      ]

      changes = Changelog.dep_changes_in_order(deps, deps)
      assert changes == [], "No Git dependencies should show as changed when unchanged"
    end

    test "mixed changes in multiple Git dependencies" do
      old_deps = [
        %Mix.Dep{
          app: :unchanged,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/unchanged.git",
               "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :changed,
          top_level: true,
          status: {:ok, "2.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/changed.git",
               "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", []}
          ],
          deps: []
        }
      ]

      new_deps = [
        %Mix.Dep{
          app: :unchanged,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock:
              {:git, "https://github.com/owner/unchanged.git",
               "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", []}
          ],
          deps: []
        },
        %Mix.Dep{
          app: :changed,
          top_level: true,
          status: {:ok, "2.0.1"},
          opts: [
            lock:
              {:git, "https://github.com/owner/changed.git",
               "cccccccccccccccccccccccccccccccccccccccc", []}
          ],
          deps: []
        }
      ]

      changes = Changelog.dep_changes_in_order(old_deps, new_deps)

      assert length(changes) == 1
      {app, _old_v, _new_v} = hd(changes)
      assert app == :changed
    end
  end

  describe "Git dependencies with tags and branches" do
    test "Git dependency with tag shows commit change" do
      old_tagged = %Mix.Dep{
        app: :tagged_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", [tag: "v1.0.0"]}
        ],
        deps: []
      }

      new_tagged = %Mix.Dep{
        app: :tagged_dep,
        top_level: true,
        status: {:ok, "1.1.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "def456789012345678901234567890abcdef4567", [tag: "v1.1.0"]}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([old_tagged], [new_tagged])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :tagged_dep
      # Should show commit hashes, not tags
      assert old_v.display == "owner/repo@abc123de"
      assert new_v.display == "owner/repo@def45678"
    end

    test "Git dependency with branch shows commit change" do
      old_branch = %Mix.Dep{
        app: :branch_dep,
        top_level: true,
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "abc123def456789012345678901234567890abcd", [branch: "main"]}
        ],
        deps: []
      }

      new_branch = %Mix.Dep{
        app: :branch_dep,
        top_level: true,
        # Version unchanged but commit changed
        status: {:ok, "1.0.0"},
        opts: [
          lock:
            {:git, "https://github.com/owner/repo.git",
             "def456789012345678901234567890abcdef4567", [branch: "main"]}
        ],
        deps: []
      }

      changes = Changelog.dep_changes_in_order([old_branch], [new_branch])

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :branch_dep
      assert old_v.display == "owner/repo@abc123de"
      assert new_v.display == "owner/repo@def45678"
    end
  end

  describe "Edge cases" do
    test "new dependency added" do
      old_deps = []

      new_deps = [
        %Mix.Dep{
          app: :new_dep,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock: {:hex, :new_dep, "1.0.0", "abc123", [:mix], [], "hexpm", "checksum"}
          ],
          deps: []
        }
      ]

      changes = Changelog.dep_changes_in_order(old_deps, new_deps)

      assert length(changes) == 1
      {app, old_v, new_v} = hd(changes)
      assert app == :new_dep
      assert old_v == nil
      assert new_v.display == "1.0.0"
    end

    test "dependency removed" do
      old_deps = [
        %Mix.Dep{
          app: :removed_dep,
          top_level: true,
          status: {:ok, "1.0.0"},
          opts: [
            lock: {:hex, :removed_dep, "1.0.0", "abc123", [:mix], [], "hexpm", "checksum"}
          ],
          deps: []
        }
      ]

      new_deps = []

      # Removed deps won't show in changes since we only process new_deps
      changes = Changelog.dep_changes_in_order(old_deps, new_deps)
      assert changes == []
    end
  end
end
