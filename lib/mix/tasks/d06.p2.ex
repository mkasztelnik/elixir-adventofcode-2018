defmodule Mix.Tasks.D06.P2 do
  use Mix.Task

  import AdventOfCode2018.Day06

  @shortdoc "Day 06 Part 2"
  def run(_) do
    input = File.stream!("inputs/d06.txt")

    input
    |> part2(10_000)
    |> IO.inspect(label: "Part 2 Results")
  end
end
