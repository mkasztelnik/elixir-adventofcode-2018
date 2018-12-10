defmodule AdventOfCode2018.Day10Test do
  use ExUnit.Case

  import AdventOfCode2018.Day10

  test "part1" do
    {:ok, io} = StringIO.open("""
                              position=< 9,  1> velocity=< 0,  2>
                              position=< 7,  0> velocity=<-1,  0>
                              position=< 3, -2> velocity=<-1,  1>
                              position=< 6, 10> velocity=<-2, -1>
                              position=< 2, -4> velocity=< 2,  2>
                              position=<-6, 10> velocity=< 2, -2>
                              position=< 1,  8> velocity=< 1, -1>
                              position=< 1,  7> velocity=< 1,  0>
                              position=<-3, 11> velocity=< 1, -2>
                              position=< 7,  6> velocity=<-1, -1>
                              position=<-2,  3> velocity=< 1,  0>
                              position=<-4,  3> velocity=< 2,  0>
                              position=<10, -3> velocity=<-1,  1>
                              position=< 5, 11> velocity=< 1, -2>
                              position=< 4,  7> velocity=< 0, -1>
                              position=< 8, -2> velocity=< 0,  1>
                              position=<15,  0> velocity=<-2,  0>
                              position=< 1,  6> velocity=< 1,  0>
                              position=< 8,  9> velocity=< 0, -1>
                              position=< 3,  3> velocity=<-1,  1>
                              position=< 0,  5> velocity=< 0, -1>
                              position=<-2,  2> velocity=< 2,  0>
                              position=< 5, -2> velocity=< 1,  2>
                              position=< 1,  4> velocity=< 2,  1>
                              position=<-2,  7> velocity=< 2, -2>
                              position=< 3,  6> velocity=<-1, -1>
                              position=< 5,  0> velocity=< 1,  0>
                              position=<-6,  0> velocity=< 2,  0>
                              position=< 5,  9> velocity=< 1, -2>
                              position=<14,  7> velocity=<-2,  0>
                              position=<-3,  6> velocity=< 2, -1>
                              """)
    result = part1(IO.stream(io, :line))

    assert result == [
      {{9, 7}, {0, 2}}, {{4, 0}, {-1, 0}}, {{0, 1}, {-1, 1}}, {{0, 7}, {-2, -1}},
      {{8, 2}, {2, 2}}, {{0, 4}, {2, -2}}, {{4, 5}, {1, -1}}, {{4, 7}, {1, 0}},
      {{0, 5}, {1, -2}}, {{4, 3}, {-1, -1}}, {{1, 3}, {1, 0}}, {{2, 3}, {2, 0}},
      {{7, 0}, {-1, 1}}, {{8, 5}, {1, -2}}, {{4, 4}, {0, -1}}, {{8, 1}, {0, 1}},
      {{9, 0}, {-2, 0}}, {{4, 6}, {1, 0}}, {{8, 6}, {0, -1}}, {{0, 6}, {-1, 1}},
      {{0, 2}, {0, -1}}, {{4, 2}, {2, 0}}, {{8, 4}, {1, 2}}, {{7, 7}, {2, 1}},
      {{4, 1}, {2, -2}}, {{0, 3}, {-1, -1}}, {{8, 0}, {1, 0}}, {{0, 0}, {2, 0}},
      {{8, 3}, {1, -2}}, {{8, 7}, {-2, 0}}, {{3, 3}, {2, -1}}]
  end

  test "part2" do
    {:ok, io} = StringIO.open("""
                              position=< 9,  1> velocity=< 0,  2>
                              position=< 7,  0> velocity=<-1,  0>
                              position=< 3, -2> velocity=<-1,  1>
                              position=< 6, 10> velocity=<-2, -1>
                              position=< 2, -4> velocity=< 2,  2>
                              position=<-6, 10> velocity=< 2, -2>
                              position=< 1,  8> velocity=< 1, -1>
                              position=< 1,  7> velocity=< 1,  0>
                              position=<-3, 11> velocity=< 1, -2>
                              position=< 7,  6> velocity=<-1, -1>
                              position=<-2,  3> velocity=< 1,  0>
                              position=<-4,  3> velocity=< 2,  0>
                              position=<10, -3> velocity=<-1,  1>
                              position=< 5, 11> velocity=< 1, -2>
                              position=< 4,  7> velocity=< 0, -1>
                              position=< 8, -2> velocity=< 0,  1>
                              position=<15,  0> velocity=<-2,  0>
                              position=< 1,  6> velocity=< 1,  0>
                              position=< 8,  9> velocity=< 0, -1>
                              position=< 3,  3> velocity=<-1,  1>
                              position=< 0,  5> velocity=< 0, -1>
                              position=<-2,  2> velocity=< 2,  0>
                              position=< 5, -2> velocity=< 1,  2>
                              position=< 1,  4> velocity=< 2,  1>
                              position=<-2,  7> velocity=< 2, -2>
                              position=< 3,  6> velocity=<-1, -1>
                              position=< 5,  0> velocity=< 1,  0>
                              position=<-6,  0> velocity=< 2,  0>
                              position=< 5,  9> velocity=< 1, -2>
                              position=<14,  7> velocity=<-2,  0>
                              position=<-3,  6> velocity=< 2, -1>
                              """)
    result = part2(IO.stream(io, :line))

    assert result == 3
  end
end
