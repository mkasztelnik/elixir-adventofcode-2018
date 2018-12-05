defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode2018.Day05

  @shortdoc "Day 05 Part 1"
  def run(_) do
    input = File.read!("inputs/d05.txt") |> String.trim

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
