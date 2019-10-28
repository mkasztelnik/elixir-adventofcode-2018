defmodule AdventOfCode2018.Day15Test do
  use ExUnit.Case

  import AdventOfCode2018.Day15

  # describe "part1" do
  #   test "test case 1" do
  #     {:ok, io} = StringIO.open("""
  #         ########
  #         ##.G...#
  #         ##...EG#
  #         ##.#.#G#
  #         ##..G#E#
  #         ##.....#
  #         ########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 27730
  #   end
  #
  #   test "test case 2" do
  #     {:ok, io} = StringIO.open("""
  #         ########
  #         ##G..#E#
  #         ##E#E.E#
  #         ##G.##.#
  #         ##...#E#
  #         ##...E.#
  #         ########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 36334
  #   end
  #
  #   test "test case 3" do
  #     {:ok, io} = StringIO.open("""
  #         ########
  #         ##E..EG#
  #         ##.#G.E#
  #         ##E.##E#
  #         ##G..#.#
  #         ##..E#.#
  #         ########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 39514
  #   end
  #
  #   test "test case 4" do
  #     {:ok, io} = StringIO.open("""
  #         ########
  #         ##E.G#.#
  #         ##.#G..#
  #         ##G.#.G#
  #         ##G..#.#
  #         ##...E.#
  #         ########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 27755
  #   end
  #
  #   test "test case 5" do
  #     {:ok, io} = StringIO.open("""
  #         ########
  #         ##.E...#
  #         ##.#..G#
  #         ##.###.#
  #         ##E#G#G#
  #         ##...#G#
  #         ########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 28944
  #   end
  #
  #   test "test case 6" do
  #     {:ok, io} = StringIO.open("""
  #         ##########
  #         ##G......#
  #         ##.E.#...#
  #         ##..##..G#
  #         ##...##..#
  #         ##...#...#
  #         ##.G...G.#
  #         ##.....G.#
  #         ##########
  #         """)
  #
  #     result = part1(IO.stream(io, :line))
  #
  #     assert result == 18740
  #   end
  # end

  describe "part2" do
    test "test case 1" do
      {:ok, io} = StringIO.open("""
          ########
          ##.G...#
          ##...EG#
          ##.#.#G#
          ##..G#E#
          ##.....#
          ########
          """)
      result = part2(IO.stream(io, :line))

      assert result == 4988
    end

    test "test case 2" do
      {:ok, io} = StringIO.open("""
          ########
          ##E..EG#
          ##.#G.E#
          ##E.##E#
          ##G..#.#
          ##..E#.#
          ########
          """)
      result = part2(IO.stream(io, :line))

      assert result == 31284
    end

    test "test case 3" do
      {:ok, io} = StringIO.open("""
          ########
          ##E.G#.#
          ##.#G..#
          ##G.#.G#
          ##G..#.#
          ##...E.#
          ########
          """)
      result = part2(IO.stream(io, :line))

      assert result == 3478
    end

    test "test case 4" do
      {:ok, io} = StringIO.open("""
          ########
          ##.E...#
          ##.#..G#
          ##.###.#
          ##E#G#G#
          ##...#G#
          ########
          """)
      result = part2(IO.stream(io, :line))

      assert result == 6474
    end

    test "test case 5" do
      {:ok, io} = StringIO.open("""
          ##########
          ##G......#
          ##.E.#...#
          ##..##..G#
          ##...##..#
          ##...#...#
          ##.G...G.#
          ##.....G.#
          ##########
          """)
      result = part2(IO.stream(io, :line))

      assert result == 1140
    end
  end
end
