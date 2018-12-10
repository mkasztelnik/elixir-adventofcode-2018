defmodule AdventOfCode2018.Day10 do

  def part1(file_stream) do
    {points_with_velocities, _} =
      points(file_stream)
      |> find_with_minimum_bounding_box()

    points_with_velocities
  end

  def part2(file_stream) do
    {_, generation} =
      points(file_stream)
      |> find_with_minimum_bounding_box()

    generation
  end

  defp find_with_minimum_bounding_box(points) do
    bounding_box_size =
      points
      |> bounding_box()
      |> bounding_box_size()

    Stream.cycle(1..10)
    |> Enum.reduce_while({points, bounding_box_size, 0}, fn _, {points, bounding_box_size, generation} ->
      new_points = tick(points)
      new_bounding_box_size =
        new_points
        |> bounding_box()
        |> bounding_box_size()
      case new_bounding_box_size < bounding_box_size do
        true ->  {:cont, {new_points, new_bounding_box_size, generation + 1}}
        false -> {:halt, {points, generation}}
      end
    end)
  end

  defp tick(points) do
    Enum.map(points, fn {{x, y}, {v_x, v_y}} -> {{x + v_x, y + v_y}, {v_x, v_y}} end)
  end

  def print(points) do
    {x_range, y_range} = bounding_box(points)
    points_set = Enum.reduce(points, MapSet.new, fn {point, _}, acc -> MapSet.put(acc, point) end)

    Enum.each(y_range, fn y ->
      Enum.reduce(x_range, [], fn x, acc ->
        if MapSet.member?(points_set, {x, y}), do: ['#' | acc], else: ['.' | acc]
      end)
      |> Enum.reverse()
      |> IO.puts
    end)

    points
  end

  defp bounding_box(points) do
    {{{x_min, _}, _}, {{x_max, _}, _}} = Enum.min_max_by(points, fn {{x, _}, _} -> x end)
    {{{_, y_min}, _}, {{_, y_max}, _}} = Enum.min_max_by(points, fn {{_, y}, _} -> y end)

    {x_min..x_max, y_min..y_max}
  end

  defp bounding_box_size({x_min..x_max, y_min..y_max}) do
    abs(x_max - x_min) * abs(y_max - y_min)
  end

  defp points(file_stream) do
    file_stream
    |> Enum.map(&parse/1)
  end

  defp parse(line) do
    [x, y, v_x, v_y | _] =
      String.split(line, ["position=<", ", ", "> velocity=<", ">"], trim: true)
      |> Enum.map(fn nr -> nr |> String.trim end)

    {{String.to_integer(x), String.to_integer(y)},
     {String.to_integer(v_x), String.to_integer(v_y)}}
  end
end
