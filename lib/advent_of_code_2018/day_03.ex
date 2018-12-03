defmodule AdventOfCode2018.Day03 do
  @pattern ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/

  def part1(file_stream) do
    {_, duplicates} =
      file_stream
      |> Stream.map(&extract_claim/1)
      |> Stream.flat_map(&to_fields/1)
      |> Enum.reduce({MapSet.new, MapSet.new}, fn x, {visited, duplicates} ->
        new_duplicates = if MapSet.member?(visited, x),
                          do: MapSet.put(duplicates, x),
                          else: duplicates
        new_visited = MapSet.put(visited, x)

        {new_visited, new_duplicates}
      end)

    MapSet.size(duplicates)
  end

  defp to_fields(%{"left" => l, "top" => t, "height" => h, "width" => w}) do
    for x <- 1..w, y <- 1..h, do: {x + l, y + t}
  end

  defp extract_claim(line) do
    %{"left" => l, "top" => t, "height" => h, "width" => w, "id"  => id} =
      Regex.named_captures(@pattern, line)

    %{
      "left" => String.to_integer(l),
      "top" => String.to_integer(t),
      "height" => String.to_integer(h),
      "width" => String.to_integer(w),
      "id" => String.to_integer(id)
    }
  end

  def part2(file_stream) do
    plans =
      file_stream
      |> Stream.map(&extract_claim/1)
      |> Stream.map(fn %{"id" => id} = claim ->
        {id, MapSet.new(to_fields(claim))}
      end)

    plans
    |> Enum.reduce(plans, fn {id, fields}, acc ->
      acc |> Enum.filter(fn {acc_id, acc_fields} ->
        id == acc_id || MapSet.disjoint?(acc_fields, fields)
      end)
    end)
    |> unique
  end

  def unique([{id, _}]), do: id
  def unique(_), do: "cannot find unique claim"
end
