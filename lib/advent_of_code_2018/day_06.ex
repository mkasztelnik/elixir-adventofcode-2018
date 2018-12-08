defmodule AdventOfCode2018.Day06 do

  defmodule MinDistanceMap do
    require FrequencyMap

    defstruct data: %{}

    def new do
      %MinDistanceMap{}
    end

    def max_finite_field(%MinDistanceMap{data: data}, infinities) do
      finite? = fn point -> !MapSet.member?(infinities, point) end
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
                distance == point_distance -> {distance, [point | coordinates]}
                distance > point_distance  -> init_value
                true                       -> {distance, coordinates}
              end
            end)
          data, :done -> %MinDistanceMap{data: data}
          _, :halt -> :ok
        end

        {data, collector_fun}
      end
    end
  end


  defmodule DistanceSumMap do
    defstruct data: %{}

    def new do
      %DistanceSumMap{}
    end

    def area_with_distance_less_than(%DistanceSumMap{data: data}, max_distance) do
      data
      |> Enum.count(fn {_, distance} -> distance < max_distance end)
    end

    defimpl Collectable do
      def into(%DistanceSumMap{data: data}) do
        collector_fun = fn
          data, {:cont, {{c_x, c_y} = coordinate, {p_x, p_y}}} ->
            distance = abs(c_x - p_x) + abs(c_y - p_y)
            Map.update(data, coordinate, distance, &(&1 + distance))
          data, :done -> %DistanceSumMap{data: data}
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

    infinities = find_infinities(min_distance_map, boundries)
                 |> IO.inspect(label: "infinities")

    {_, field_size} =
      MinDistanceMap.max_finite_field(min_distance_map, infinities)

    field_size
  end

  def part2(file_stream, max_distance) do
    coordinates = to_coordinates(file_stream)

    boundries = boundries(coordinates)
    {{x_min, x_max}, {y_min, y_max}} = boundries

    distance_sum_map = for x <- x_min..x_max,
                           y <- y_min..y_max,
                           coordinate <- coordinates,
                         do: {{x, y}, coordinate},
                         into: DistanceSumMap.new

    DistanceSumMap.area_with_distance_less_than(distance_sum_map, max_distance)
  end

  defp find_infinities(%MinDistanceMap{data: data}, {{x_min, x_max}, {y_min, y_max}}) do
    data
    |> Enum.reduce(MapSet.new, fn
      {{x, y}, {_, [point]}}, acc ->
        if x in [x_min, x_max] ||  y in [y_min, y_max] do
          MapSet.put(acc, point)
        else
          acc
        end
      _ , acc-> acc
    end)
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

end
