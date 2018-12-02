defmodule AdventOfCode2018.Day02 do
  def part1(args) do
    doubles_triples = Enum.map(args, &doubles_triples/1)
    doubles = Enum.count(doubles_triples, fn {double, _} -> double != nil end)
    triples = Enum.count(doubles_triples, fn {_, triple} -> triple != nil end)

    doubles * triples
  end

  defp doubles_triples(sequence) do
    times = sequence
    |> String.codepoints
    |> Enum.group_by(&(&1))
    |> Enum.map(fn {_, v} -> length(v) end)

    {
       Enum.find(times, &(&1 == 2)),
       Enum.find(times, &(&1 == 3))
    }
  end

  def part2(args) do
  end
end
