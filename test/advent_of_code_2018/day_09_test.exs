defmodule AdventOfCode2018.Day09Test do
  use ExUnit.Case

  import AdventOfCode2018.Day09

  test "test case 1" do
    result = part1("9 players; last marble is worth 25 points")

    assert result == 32
  end

  test "test case 2" do
    result = part1("10 players; last marble is worth 1618 points")

    assert result == 8317
  end

  test "test case 3" do
    result = part1("13 players; last marble is worth 7999 points")

    assert result == 146373
  end

  test "test case 4" do
    result = part1("17 players; last marble is worth 1104 points")

    assert result == 2764
  end

  test "test case 5" do
    result = part1("21 players; last marble is worth 6111 points")

    assert result == 54718
  end

  test "test case 6" do
    result = part1("30 players; last marble is worth 5807 points")

    assert result == 37305
  end
end
