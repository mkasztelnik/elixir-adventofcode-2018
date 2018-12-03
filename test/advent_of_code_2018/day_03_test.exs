defmodule AdventOfCode2018.Day03Test do
  use ExUnit.Case

  import AdventOfCode2018.Day03

  test "part1" do
    {:ok, io} = StringIO.open("""
                              #1 @ 1,3: 4x4
                              #2 @ 3,1: 4x4
                              #3 @ 5,5: 2x2
                              """)
    result = part1(IO.stream(io, :line))

    assert result == 4
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
