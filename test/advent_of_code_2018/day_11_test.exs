defmodule AdventOfCode2018.Day11Test do
  use ExUnit.Case

  import AdventOfCode2018.Day11

  describe "part1" do
    test "test case 1" do
      assert part1(18) == {33, 45}
    end

    test "test case 2" do
      assert part1(42) == {21, 61}
    end
  end

  describe "part2" do
    test "test case 1" do
      assert part2(18) == {{90, 269}, 16}
    end

    test "test case 2" do
      assert part2(42) == {{232, 251}, 12}
    end
  end

  describe "power level" do
    test "test case 1" do
      assert AdventOfCode2018.Day11.power_level({3, 5}, 8) == 4
    end

    test "test case 2" do
      assert AdventOfCode2018.Day11.power_level({122, 79}, 57) == -5
    end

    test "test case 3" do
      assert AdventOfCode2018.Day11.power_level({217, 196}, 39) == 0
    end

    test "test case 4" do
      assert AdventOfCode2018.Day11.power_level({101, 153}, 71) == 4
    end

  end
end
