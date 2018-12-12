defmodule AdventOfCode2018.Day12Test do
  use ExUnit.Case

  import AdventOfCode2018.Day12

  test "part1" do
    {:ok, io} = StringIO.open("""
        initial state: #..#.#..##......###...###

        ...## => #
        ..#.. => #
        .#... => #
        .#.#. => #
        .#.## => #
        .##.. => #
        .#### => #
        #.#.# => #
        #.### => #
        ##.#. => #
        ##.## => #
        ###.. => #
        ###.# => #
        ####. => #
        """)

    result = part1(IO.stream(io, :line))

    assert result == 325
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
