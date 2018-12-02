defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode2018.Day02

  @shortdoc "Day 02 Part 1"
  def run(_) do
    input = AdventOfCode2018.input!("inputs/d02.txt")

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
