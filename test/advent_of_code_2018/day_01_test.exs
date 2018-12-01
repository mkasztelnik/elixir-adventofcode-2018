defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  test "part1 test case 1" do
    input = input!("+1, +1, +1")
    result = part1(input)

    assert result == 3
  end

  test "part1 test case 2" do
    input = input!("+1, +1, -2")
    result = part1(input)

    assert result == 0
  end

  test "part1 test case 3" do
    input = input!("-1, -2, -3")
    result = part1(input)

    assert result == -6
  end

  test "part2 test case 1" do
    input = input!("+1, -1")
    result = part2(input)

    assert result == 0
  end

  test "part2 test case 2" do
    input = input!("+3, +3, +4, -2, -4")
    result = part2(input)

    assert result == 10
  end

  test "part2 test case 3" do
    input = input!("-6, +3, +8, +5, -6")
    result = part2(input)

    assert result == 5
  end

  test "part2 test case 4" do
    input = input!("+7, +7, -2, -7, -4")
    result = part2(input)

    assert result == 14
  end

  def input!(str) do
    str |> String.split(",") |> Enum.map(&String.trim/1)
  end
end
