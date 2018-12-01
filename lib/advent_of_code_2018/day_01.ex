defmodule AdventOfCode2018.Day01 do
  def part1(args) do
    args |> Enum.map(&parse/1) |> Enum.sum
  end

  defp parse(value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> 0
    end
  end

  def part2(args) do
  end
end
