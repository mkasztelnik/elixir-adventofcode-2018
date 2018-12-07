defmodule AdventOfCode2018.Day07 do
  def part1(file_stream) do
    file_stream
    |> Enum.reduce(%{}, fn line, acc ->
      {job, dependent} = parse(line)

      acc
      |> Map.update(job, MapSet.new([dependent]), &(Set.put(&1, dependent)))
      |> Map.update(dependent, MapSet.new, &(&1))
    end)
    |> order
  end

  defp order(dependencies) do
    order(dependencies, MapSet.new, [])
  end
  defp order(dependencies, _, acc) when dependencies == %{} do
    acc |> Enum.reverse |> List.to_string
  end
  defp order(dependencies, finished, acc) do
    [{next, _} | _] =
      dependencies
      |> Enum.filter(fn {_, dependent} -> MapSet.subset?(dependent, finished) end)
      |> Enum.sort(fn {first, _}, {second, _} -> first <= second end)

    order(Map.delete(dependencies, next), Set.put(finished, next), [next | acc])
  end

  def parse("Step " <> <<dependent::utf8>> <> " must be finished before step " <>
            <<job::utf8>> <> <<_::binary>>) do
    {job, dependent}
  end

  def part2(args) do
  end
end
