defmodule Mix.Tasks.D02.P2 do
  use Mix.Task

  import AdventOfCode2018.Day02

  @shortdoc "Day 02 Part 2"
  def run(_) do
    input = AdventOfCode2018.input!("inputs/d02.txt")

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
