defmodule AdventOfCode2018.Day11 do
  # Optimal solution can be implemented using this algorithm:
  # https://en.wikipedia.org/wiki/Summed-area_table

  def part1(grid_serial_number) do
    {point, _} =
      grid(grid_serial_number)
      |> max_power_level(3)

    point
  end

  def part2(grid_serial_number) do
    grid = grid(grid_serial_number)

    {:ok, {point, _, size}} =
    1..300
    |> Task.async_stream(fn size ->
      {point, power_level} = max_power_level(grid, size)
      {point, power_level, size}
    end, ordered: false)
    |> Enum.max_by(fn {:ok, {_, power_level, _}} -> power_level end)

    {point, size}
  end

  def max_power_level(grid, size) when is_tuple(grid) do
    {point, power_level, _} =
      Enum.reduce(0..(300 - size), {nil, nil, nil}, fn x, {point, power_level, rows} ->
        new_rows =
        case x do
          0 -> rows_count(grid, size)
          _ -> next_rows_count(grid, rows, size, x)
        end

        {new_point, new_power_level} =
          Enum.reduce(0..(300 - size), {point, power_level}, fn y, {_, power_level} = acc ->
            case {x, y} do
              {0, 0} ->
                {{1, 1}, square_power_level(new_rows, y, size)}
              _ ->
                new_power_level = square_power_level(new_rows, y, size)
                case new_power_level > power_level do
                  true -> {{x + 1, y + 1}, new_power_level}
                  false -> acc
                end
            end
          end)

        {new_point, new_power_level, new_rows}
      end)

    {point, power_level}
  end

  defp square_power_level(rows, start_y, size) do
    Enum.reduce(start_y..(start_y + size - 1), 0, fn y, acc -> acc + elem(rows, y) end)
  end


  def rows_count(grid, size) do
    Enum.reduce(0..299, [], fn y, acc ->
      row = Enum.reduce(0..(size - 1), 0, fn x, acc -> acc + grid_val(grid, x, y) end)
      [row | acc]
    end)
    |> Enum.reverse()
    |> List.to_tuple()
  end


  def next_rows_count(grid, rows, size, x) do
    0..299
    |> Enum.reduce([], fn y, acc ->
      [elem(rows, y) - grid_val(grid, x - 1, y) + grid_val(grid, x + size - 1, y) | acc]
    end)
    |> Enum.reverse()
    |> List.to_tuple()
  end

  defp grid_val(grid, x, y) do
    grid |> elem(x) |> elem(y)
  end

  def power_level({x, y}, grid_serial_number) do
    rack_id = x + 10
    (((rack_id * y + grid_serial_number) * rack_id) |> div(100) |> rem(10)) - 5
  end

  def grid(grid_serial_number) do
    Enum.reduce(1..300, [], fn x, rows ->
      elem =
        Enum.reduce(1..300, [], fn y, row ->
          [power_level({x, y}, grid_serial_number) | row]
        end)
        |> Enum.reverse()
        |> List.to_tuple()
      [elem | rows]
    end)
      |> Enum.reverse()
    |> List.to_tuple()
  end
end
