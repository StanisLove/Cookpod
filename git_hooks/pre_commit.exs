#! /usr/bin/env elixir

{unstaged_files, _} = System.cmd("git", ["ls-files", "-m"])
{changed_files, _} = System.cmd("git", ["status", "--porcelain"])

unstaged_files = String.split(unstaged_files, "\n")

changed_files =
  String.split(changed_files, "\n")
  |> Enum.filter(fn x -> Regex.match?(~r/^\s*(A|AM|M)/, x) end)
  |> Enum.map(fn x ->
    String.split(x, " ")
    |> Enum.filter(fn x ->
      Regex.match?(~r/(\.ex|\.exs)/, Path.extname(x))
    end)
  end)
  |> List.flatten()

unstaged_files = unstaged_files -- changed_files
changed_files = changed_files -- unstaged_files

if Enum.empty?(changed_files), do: System.stop(0)

System.cmd("mix", ["format" | changed_files])

# Add prefix see https://github.com/rrrene/credo-proposals/issues/4
changed_files = Enum.reduce(changed_files, [], fn x, acc -> ["--files-included", x | acc] end)

{output, status} = System.cmd("mix", ["credo", "--strict" | changed_files])

if status == 0, do: System.halt(0)

IO.puts(output)
