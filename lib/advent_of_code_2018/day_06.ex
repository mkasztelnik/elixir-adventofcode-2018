defmodule AdventOfCode2018.Day06 do

  defmodule MinDistanceMap do
    require FrequencyMap

    defstruct data: %{}

    def new do
      %MinDistanceMap{}
    end

    def max_finite_field_size(%MinDistanceMap{data: data}, {{x_min, x_max}, {y_min, y_max}}) do
      finite? = fn {x, y} -> x != x_min && x != x_max && y != y_min && y != y_max end
      frequency_map = for {_, {_, [coordinate]}} <- data, finite?.(coordinate),
                        do: coordinate, into: FrequencyMap.new

      FrequencyMap.most_frequent(frequency_map)
    end

    defimpl Collectable do
      def into(%MinDistanceMap{data: data}) do
        collector_fun = fn
          data, {:cont, {{c_x, c_y} = coordinate, {p_x, p_y} = point}} ->
            point_distance = abs(c_x - p_x) + abs(c_y - p_y)
            init_value = {point_distance, [point]}
            Map.update(data, coordinate, init_value, fn {distance, coordinates} ->
              cond do
                distance - point_distance > 0 -> {point_distance, [point]}
                distance == point_distance    -> {distance, [point | coordinates]}
                true                          -> {distance, coordinates}
              end
            end)
          data, :done -> %MinDistanceMap{data: data}
          _, :halt -> :ok
        end

        {data, collector_fun}
      end
    end
  end

  def part1(file_stream) do
    coordinates = to_coordinates(file_stream)
    boundries = boundries(coordinates)
    {{x_min, x_max}, {y_min, y_max}} = boundries


    min_distance_map = for x <- x_min..x_max,
                           y <- y_min..y_max,
                           coordinate <- coordinates,
                         do: {{x, y}, coordinate},
                         into: MinDistanceMap.new

    {_, field_size} =
      MinDistanceMap.max_finite_field_size(min_distance_map, boundries)

    field_size
  end

  defp boundries(coordinates) do
    coordinates
    |> Enum.reduce({{nil, 0}, {nil, 0}}, fn {x, y}, acc ->
      {{x_min, x_max}, {y_min, y_max}} = acc
      {
        {min(x_min, x), max(x_max, x)},
        {min(y_min, y), max(y_max, y)}
      }
    end)
  end

  defp to_coordinates(file_stream) do
    file_stream
    |> Enum.map(fn line ->
      [x, y] = line |> String.trim |> String.split(", ")
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def part2(args) do
  end
end
