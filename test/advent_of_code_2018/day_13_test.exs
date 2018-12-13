defmodule AdventOfCode2018.Day13Test do
  use ExUnit.Case

  import AdventOfCode2018.Day13

  test "part1" do
    input = File.stream!("inputs/d13-test.txt")
    result = part1(input)

    assert result == {7, 3}
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
