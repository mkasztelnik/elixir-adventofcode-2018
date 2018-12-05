defmodule AdventOfCode2018.Day05 do
  @offset ?a - ?A

  def part1(polymer) do
    {reduced, _ } =
      polymer
      |> String.to_charlist
      |> reduce()

    length(reduced)
  end

  defguard is_reactive(a, b) when abs(a - b) == @offset

  defp reduce(polymer) do
    reduce(polymer, [], MapSet.new, false)
  end
  defp reduce([first, second | tail], acc, reactive, modified) when is_reactive(first, second) do
    reduce(tail, acc, MapSet.put(reactive, min(first, second)), true)
  end
  defp reduce([head | tail], acc, reactive, modified) do
    reduce(tail, [head | acc], reactive, modified)
  end
  defp reduce([], acc, reactive, false) do
    {acc, reactive}
  end
  defp reduce([], acc, reactive, true) do
    reduce(acc, [], reactive, false)
  end

  def part2(polymer) do
    polymer_charlist = String.to_charlist(polymer)
    {_, reactives} = reduce(polymer_charlist)

    reactives
    |> Stream.map(fn reactive ->
      {reduced, _} =
        Enum.reject(polymer_charlist, fn ch ->
          diff = abs(ch - reactive)
          diff == 0 || diff == @offset
        end)
        |> reduce()
      length(reduced)
    end)
    |> Enum.min
  end
end
