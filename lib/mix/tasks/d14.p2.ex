defmodule Mix.Tasks.D14.P2 do
  use Mix.Task

  import AdventOfCode2018.Day14

  @shortdoc "Day 14 Part 2"
  def run(_) do
    part2([3, 7], [7, 0, 4, 3, 2, 1])
    |> IO.inspect(label: "Part 2 Results")
  end
end
