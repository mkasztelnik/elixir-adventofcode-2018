defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  test "part1" do
    result = part1("dabAcCaCBAcCcaDA")

    assert result == 10
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
