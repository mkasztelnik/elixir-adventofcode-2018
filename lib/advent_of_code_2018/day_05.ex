defmodule AdventOfCode2018.Day05 do
  def part1(polymer) do
    {reduced, _ } =
      polymer
      |> String.to_charlist
      |> reduce()

    length(reduced)
  end

  defp reduce(polymer) do
    reduce(polymer, [], MapSet.new, false)
  end
  defp reduce([first, second | tail] = polymer, acc, reactive, modified) do
    case abs(first - second) do
      32 -> reduce(tail, acc, MapSet.put(reactive, min(first, second)), true)
      _  -> reduce([second | tail], [first | acc], reactive, modified)
    end
  end
  defp reduce([head], acc, reactive, false) do
    {[head | acc], reactive}
  end
  defp reduce([head], acc, reactive, true) do
    [head | acc]
    |> reduce([], reactive, false)
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
          diff == 0 || diff == 32
        end)
        |> reduce()
      length(reduced)
    end)
    |> Enum.min
  end
end
