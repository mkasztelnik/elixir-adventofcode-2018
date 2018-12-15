defmodule AdventOfCode2018.Day14Test do
  use ExUnit.Case

  import AdventOfCode2018.Day14

  describe "part1" do
    test "test case 1" do
      assert part1([3, 7], 9) == [5, 1, 5, 8, 9, 1, 6, 7, 7, 9]
    end

    test "test case 2" do
      assert part1([3, 7], 5) == [0, 1, 2, 4, 5, 1, 5, 8, 9, 1]
    end

    test "test case 3" do
      assert part1([3, 7], 18) == [9, 2, 5, 1, 0, 7, 1, 0, 8, 5]
    end

    test "test case 4" do
      assert part1([3, 7], 2018) == [5, 9, 4, 1, 4, 2, 9, 8, 8, 2]
    end
  end

  describe "part2" do
    test "test case 1" do
      assert part2([3, 7], [5, 1, 5, 8, 9]) == 9
    end

    test "test case 2" do
      assert part2([3, 7], [0, 1, 2, 4, 5]) == 5
    end

    test "test case 3" do
      assert part2([3, 7], [9, 2, 5, 1, 0]) == 18
    end

    test "test case 4" do
      assert part2([3, 7], [5, 9, 4, 1, 4]) == 2018
    end
  end
end
