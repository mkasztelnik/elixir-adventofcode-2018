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
    codepoints = Enum.map(args, &String.codepoints/1)
    different? = fn x, y -> x != y end

    (for x <- codepoints, y <- codepoints, different?.(x, y), do: {x, y})
    |> Enum.find(&one_difference?/1)
    |> remove_difference
  end

  defp one_difference?(couple) do
    difference_count(couple) == 1
  end

  defp difference_count({first, second}) do
    Enum.zip(first, second)
    |> Enum.reject(fn {x, y} -> x == y end)
    |> length
  end

  defp remove_difference({first, second}) do
    Enum.zip(first, second)
    |> Enum.reject(fn {x, y} -> x != y end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.join
  end
end
