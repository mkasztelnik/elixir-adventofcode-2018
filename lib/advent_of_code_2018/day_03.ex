defmodule AdventOfCode2018.Day03 do
  @pattern ~r/#\d+ @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/

  def part1(file_stream) do
    {_, duplicates} =
      file_stream
      |> Stream.map(&extract_claim/1)
      |> Stream.flat_map(&to_fields/1)
      |> Enum.reduce({HashSet.new, HashSet.new}, fn x, {visited, duplicates} ->
        new_duplicates = if HashSet.member?(visited, x),
                          do: HashSet.put(duplicates, x),
                          else: duplicates
        new_visited = HashSet.put(visited, x)

        {new_visited, new_duplicates}
      end)

    HashSet.size(duplicates)
  end

  defp to_fields(%{"left" => l, "top" => t, "height" => h, "width" => w}) do
    for x <- 1..w, y <- 1..h, do: {x + l, y + t}
  end

  defp extract_claim(line) do
    %{"left" => l, "top" => t, "height" => h, "width" => w} =
      Regex.named_captures(@pattern, line)

    %{
      "left" => String.to_integer(l),
      "top" => String.to_integer(t),
      "height" => String.to_integer(h),
      "width" => String.to_integer(w)
    }
  end

  def part2(args) do
  end
end
