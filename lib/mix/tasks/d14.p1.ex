defmodule Mix.Tasks.D14.P1 do
  use Mix.Task

  import AdventOfCode2018.Day14

  @shortdoc "Day 14 Part 1"
  def run(_) do

    # part1([7, 0, 4, 3, 2, 1], 10)
    part1([3, 7], 704321)
    |> IO.inspect(label: "Part 1 Results")
  end
end
