defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode2018.Day01

  @shortdoc "Day 01 Part 2"
  def run(_) do
    input = AdventOfCode2018.input!("inputs/d01.txt")

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
