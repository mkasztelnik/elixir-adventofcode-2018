defmodule Mix.Tasks.D03.P1 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 1"
  def run(_) do
    input = File.stream!("inputs/d03.txt")

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
