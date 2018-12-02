defmodule AdventOfCode2018.Day02Test do
  use ExUnit.Case

  import AdventOfCode2018.Day02

  test "part1" do
    input = ~w(abcdef bababc abbcde abcccd aabcdd abcdee ababab)
    result = part1(input)

    assert result == 12
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
