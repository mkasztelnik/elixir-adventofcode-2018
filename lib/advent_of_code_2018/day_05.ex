defmodule AdventOfCode2018.Day05 do
  def part1(polymer) do
    polymer
    |> String.to_charlist
    |> reduce()
    |> length
  end

  defp reduce([first, second | tail] = polymer, acc \\ [], modified \\ false) do
    case abs(first - second) do
      32 -> reduce(tail, acc, true)
      _  -> reduce([second | tail], [first | acc], modified)
    end
  end
  defp reduce([head], acc, false) do
    [head | acc]
  end
  defp reduce([head], acc, true) do
    [head | acc]
    |> reduce([], false)
  end

  def part2(args) do
  end
end
