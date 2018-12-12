defmodule Mix.Tasks.D12.P1 do
  use Mix.Task

  import AdventOfCode2018.Day12

  @shortdoc "Day 12 Part 1"
  def run(_) do
    input = File.stream!("inputs/d12.txt")

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
