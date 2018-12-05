defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  test "part1" do
    result = part1("dabAcCaCBAcCcaDA")

    assert result == 10
  end

  test "part2" do
    result = part2("dabAcCaCBAcCcaDA")

    assert result == 4
  end
end
