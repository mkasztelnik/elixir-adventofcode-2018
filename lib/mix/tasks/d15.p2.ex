defmodule Mix.Tasks.D15.P2 do
  use Mix.Task

  import AdventOfCode2018.Day15

  @shortdoc "Day 15 Part 2"
  def run(_) do
    input = File.stream!("inputs/d15.txt")

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
