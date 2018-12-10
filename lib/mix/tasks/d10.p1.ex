defmodule Mix.Tasks.D10.P1 do
  use Mix.Task

  import AdventOfCode2018.Day10

  @shortdoc "Day 10 Part 1"
  def run(_) do
    input = File.stream!("inputs/d10.txt")

    input
    |> part1()
    |> print()
  end
end
