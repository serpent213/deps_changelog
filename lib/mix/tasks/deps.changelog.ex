defmodule Mix.Tasks.Deps.Changelog do
  @changelog_filename "deps.CHANGELOG.md"
  @snapshot_filename "deps.CHANGELOG.before.bin"

  @shortdoc "Collect additions to top-level dependency's CHANGELOG files"
  @moduledoc """
  Find additions to top-level dependency's CHANGELOG files upon update and accumulate them in a new
  `#{@changelog_filename}`. Any task can be specified to run to perform the update.

  ## Examples

  ```bash
  mix deps.changelog deps.update --all
  mix deps.changelog igniter.upgrade --all
  ```

  ```bash
  mix deps.changelog --before
  mix deps.unlock assent
  mix deps.get
  mix deps.changelog --after
  ```

  ## Command line options

  Instead of wrapping a specified task, you can also run the before and after actions manually:

    * `--before` - make a snapshot of the dependency's changelogs and store to file `#{@snapshot_filename}`
    * `--after` - create another snapshot, process diff and update `#{@changelog_filename}`
  """
  use Mix.Task

  defmodule Changelogs do
    @moduledoc false
    @enforce_keys [:mix_dep]
    defstruct [:mix_dep, changelog_before: nil, changelog_after: nil]

    @type t :: %__MODULE__{
            mix_dep: %Mix.Dep{},
            changelog_before: String.t() | nil,
            changelog_after: String.t() | nil
          }
  end

  def run(["--before"]) do
    try do
      original_deps_info = Mix.Dep.load_and_cache()
      changelogs_before = before_update(original_deps_info)
      record = {original_deps_info, changelogs_before}

      case File.write(@snapshot_filename, :erlang.term_to_binary(record)) do
        :ok ->
          Mix.shell().info("Changelog snapshot created successfully")

        {:error, reason} ->
          Mix.shell().error(
            "Failed to write #{@snapshot_filename}: #{:file.format_error(reason)}"
          )
      end
    rescue
      e ->
        Mix.shell().error("Error creating changelog snapshot: #{Exception.message(e)}")
        Mix.shell().error("Stacktrace: #{Exception.format_stacktrace(__STACKTRACE__)}")
    end
  end

  def run(["--after"]) do
    case File.read(@snapshot_filename) do
      {:ok, binary} ->
        try do
          {original_deps_info, changelogs_before} = :erlang.binary_to_term(binary)
          Mix.Dep.clear_cached()
          new_deps_info = Mix.Dep.load_and_cache()
          dep_changes = dep_changes_in_order(original_deps_info, new_deps_info)

          case after_update(changelogs_before, dep_changes) do
            {_, :updated} ->
              Mix.shell().info("#{@changelog_filename} updated successfully")

            {_, :no_changes} ->
              Mix.shell().info(
                "#{@changelog_filename} not updated (no changelog changes detected)"
              )
          end
        rescue
          e ->
            Mix.shell().error("Error processing changelog: #{Exception.message(e)}")
            Mix.shell().error("Stacktrace: #{Exception.format_stacktrace(__STACKTRACE__)}")
        after
          # Always cleanup, even if processing fails
          case File.rm(@snapshot_filename) do
            :ok ->
              :ok

            {:error, reason} ->
              Mix.shell().error(
                "Failed to remove #{@snapshot_filename}: #{:file.format_error(reason)}"
              )
          end
        end

      {:error, reason} ->
        Mix.shell().error("Failed to read #{@snapshot_filename}: #{:file.format_error(reason)}")
    end
  end

  def run([embedded_task | task_args]) do
    Mix.Task.reenable("deps.changelog")
    Mix.Task.run("deps.changelog", ["--before"])
    Mix.Task.run(embedded_task, task_args)
    Mix.Task.reenable("deps.changelog")
    Mix.Task.run("deps.changelog", ["--after"])
  end

  @doc false
  def before_update(original_deps_info) do
    Enum.filter(original_deps_info, & &1.top_level)
    |> Enum.map(fn dep ->
      changelog_before = read_changelog(dep)

      %Changelogs{
        mix_dep: dep,
        changelog_before: changelog_before
      }
    end)
  end

  @doc false
  def after_update(changelogs, dep_changes, timestamp \\ nil) do
    timestamp = timestamp || :calendar.local_time()

    process_deps =
      Enum.flat_map(changelogs, fn dep ->
        if List.keyfind(dep_changes, dep.mix_dep.app, 0) do
          [%{dep | changelog_after: read_changelog(dep.mix_dep)}]
        else
          []
        end
      end)
      |> Enum.sort_by(& &1.mix_dep.app)

    summary_text =
      Enum.reduce(process_deps, "", fn dep, acc ->
        package_name = dep.mix_dep.app
        {_name, old_version, new_version} = List.keyfind(dep_changes, package_name, 0)

        diff =
          List.myers_difference(
            (dep.changelog_before || "") |> String.split("\n"),
            (dep.changelog_after || "") |> String.split("\n")
          )

        insert_text =
          Enum.filter(diff, fn {op, _} -> op == :ins end)
          |> Enum.flat_map(&elem(&1, 1))
          |> limit_vertical_whitespace(2)
          |> shift_md_headings(2)
          |> Enum.join("\n")

        acc <>
          String.trim_trailing("""
          ### `#{package_name}` (#{old_version} ➞ #{new_version})

          #{insert_text}
          """) <> "\n\n\n"
      end)
      |> String.trim_trailing()

    if summary_text != "" do
      update_summary_file(summary_text, timestamp)
      {summary_text, :updated}
    else
      {summary_text, :no_changes}
    end
  end

  defp read_changelog(dep) do
    dest_path = dep.opts[:dest]

    read_changelog =
      File.read("#{dest_path}/CHANGELOG.md")
      |> case do
        {:error, _reason} -> File.read("#{dest_path}/CHANGELOG")
        {:ok, _contents} = result -> result
      end

    case read_changelog do
      {:ok, changelog_body} -> changelog_body
      {:error, _reason} -> nil
    end
  end

  defp update_summary_file(summary_text, timestamp) do
    marker = "<!-- changelog -->"

    default_header = """
    # Dependencies Change Log

    Auto-updated by `deps_changelog`. 💪

    Feel free to edit this file by hand. Updates will be inserted below the following marker:

    #{marker}
    """

    months =
      ~w(January February March April May June July August September October November December)

    {{year, month, day}, _time} = timestamp
    local_date = "#{day}. #{Enum.at(months, month - 1)} #{year}"
    date_header = underlined_md_heading("_#{local_date}_", 2) <> "\n\n"

    updated_summary =
      case File.read(@changelog_filename) do
        {:ok, content} ->
          String.replace(
            content,
            marker,
            marker <> "\n\n" <> date_header <> summary_text <> "\n\n"
          )

        _ ->
          default_header <> "\n" <> date_header <> summary_text <> "\n"
      end

    case File.write(@changelog_filename, updated_summary) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.shell().error("Failed to write #{@changelog_filename}: #{:file.format_error(reason)}")
    end
  end

  defp underlined_md_heading(text, level) do
    symbol =
      case level do
        1 -> "="
        2 -> "-"
        _ -> raise ArgumentError, "Unsupported heading level: #{level}"
      end

    underlines = String.duplicate(symbol, String.length(text))
    "#{text}\n#{underlines}"
  end

  defp shift_md_headings(lines, shift) do
    Enum.map(lines, fn line ->
      case Regex.run(~r/^(#+) /, line) do
        [_, old_prefix] ->
          new_level = min(6, String.length(old_prefix) + shift)
          new_prefix = String.duplicate("#", new_level)
          String.replace_prefix(line, old_prefix, new_prefix)

        _ ->
          line
      end
    end)
  end

  defp limit_vertical_whitespace(lines, max) do
    Enum.reduce(lines, {0, []}, fn line, {empty_count, acc} ->
      if String.trim(line) == "" do
        {empty_count + 1, acc}
      else
        {0, acc ++ Enum.take(List.duplicate("", empty_count), max) ++ [line]}
      end
    end)
    |> elem(1)
  end

  # from Igniter
  defp dep_changes_in_order(old_deps_info, new_deps_info) do
    new_deps_info
    |> sort_deps()
    |> Enum.flat_map(fn dep ->
      case Enum.find(old_deps_info, &(&1.app == dep.app)) do
        nil ->
          [{dep.app, nil, Version.parse!(elem(dep.status, 1))}]

        %{status: {:ok, old_version}} ->
          [{dep.app, Version.parse!(old_version), Version.parse!(elem(dep.status, 1))}]

        _other ->
          []
      end
    end)
    |> Enum.reject(fn {_app, old, new} ->
      old == new
    end)
  end

  # from Igniter
  defp sort_deps([]), do: []

  defp sort_deps(deps) do
    free_dep_name =
      Enum.find_value(deps, fn %{app: app, deps: children} ->
        if !Enum.any?(children, fn child ->
             Enum.any?(deps, &(&1.app == child))
           end) do
          app
        end
      end)

    next_dep_name = free_dep_name || elem(Enum.min_by(deps, &length(&1.deps)), 0)

    {[next_dep], others} = Enum.split_with(deps, &(&1.app == next_dep_name))

    [
      next_dep
      | sort_deps(
          Enum.map(others, fn dep ->
            %{dep | deps: Enum.reject(dep.deps, &(&1.app == next_dep_name))}
          end)
        )
    ]
  end
end
