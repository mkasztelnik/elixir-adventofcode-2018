defmodule AdventOfCode2018.Day13 do
  def part1(file_stream) do
    {board, carts} =
      file_stream
      |> parse()


    Stream.cycle([1])
    |> Enum.reduce_while(carts, fn _, carts ->
      {new_carts, first_conflict} =
        carts
        |> tick(board)

      case first_conflict do
        nil -> {:cont, sort(new_carts) }
        conflict -> {:halt, conflict}
      end
    end)
  end

  defp sort(carts) do
    Enum.sort(carts, fn {_, _, {x1, y1}}, {_, _, {x2, y2}} ->
      y1 < y2 || (y1 == y2 && x1 <= x2)
    end)
  end

  defp parse(file_stream) do
    {board, carts, _} =
      file_stream
      |> Enum.reduce({[], [], 0}, fn line, {board, carts, y} ->
        {board_line, line_carts} = parse_line(line, y)

        {[board_line | board], carts ++ line_carts, y + 1}
      end)

    {board |> Enum.reverse() |> List.to_tuple(), carts}
  end


  defp tick(carts, board) do
    all =
      carts |> Enum.reduce(MapSet.new, fn {_, _, point}, acc ->
        MapSet.put(acc, point)
      end)

    {new_carts, conflicted, _} =
      carts
      |> Enum.reduce({[], nil, all}, fn {_, _, point} = cart, {new_carts, conflicted, all} ->
        new_point = next_point(cart)
        board_point = board_point(board, new_point)

        conflicted =
          case {conflicted, MapSet.member?(all, new_point)} do
            {nil, true} -> new_point
            _ -> conflicted
          end

        new_all = all |> MapSet.delete(point) |> MapSet.put(new_point)
        {direction, intersection_direction} = next_direction(cart, board_point)

        {[{direction, intersection_direction, new_point} | new_carts], conflicted, new_all}
      end)

    {new_carts, conflicted}
  end

  defp next_point({:left, _, {x, y}}), do: {x - 1, y}
  defp next_point({:right, _, {x, y}}), do: {x + 1, y}
  defp next_point({:up, _, {x, y}}), do: {x, y - 1}
  defp next_point({:down, _, {x, y}}), do: {x, y + 1}

  defp next_direction({:left,  intersection_direction, _}, ?-),  do: {:left, intersection_direction}
  defp next_direction({:left,  intersection_direction, _}, ?\\), do: {:up, intersection_direction}
  defp next_direction({:left,  intersection_direction, _}, ?/),  do: {:down, intersection_direction}
  defp next_direction({:right, intersection_direction, _}, ?-),  do: {:right, intersection_direction}
  defp next_direction({:right, intersection_direction, _}, ?\\), do: {:down, intersection_direction}
  defp next_direction({:right, intersection_direction, _}, ?/),  do: {:up, intersection_direction}
  defp next_direction({:up,    intersection_direction, _}, ?|),  do: {:up, intersection_direction}
  defp next_direction({:up,    intersection_direction, _}, ?\\), do: {:left, intersection_direction}
  defp next_direction({:up,    intersection_direction, _}, ?/),  do: {:right, intersection_direction}
  defp next_direction({:down,  intersection_direction, _}, ?|),  do: {:down, intersection_direction}
  defp next_direction({:down,  intersection_direction, _}, ?\\), do: {:right, intersection_direction}
  defp next_direction({:down,  intersection_direction, _}, ?/),  do: {:left, intersection_direction}

  defp next_direction({:left,  :left, _},     ?+),  do: {:down, :straight}
  defp next_direction({:left,  :straight, _}, ?+),  do: {:left, :right}
  defp next_direction({:left,  :right, _},    ?+),  do: {:up, :left}
  defp next_direction({:right, :left, _},     ?+),  do: {:up, :straight}
  defp next_direction({:right, :straight, _}, ?+),  do: {:right, :right}
  defp next_direction({:right, :right, _},    ?+),  do: {:down, :left}
  defp next_direction({:up,    :left, _},     ?+),  do: {:left, :straight}
  defp next_direction({:up,    :straight, _}, ?+),  do: {:up, :right}
  defp next_direction({:up,    :right, _},    ?+),  do: {:right, :left}
  defp next_direction({:down,  :left, _},     ?+),  do: {:right, :straight}
  defp next_direction({:down,  :straight, _}, ?+),  do: {:down, :right}
  defp next_direction({:down,  :right, _},    ?+),  do: {:left, :left}

  defp board_point(board, {x, y}), do: board |> elem(y) |> elem(x)

  def parse_line(line, y) do
    {board_line, carts, _} = do_parse_line(line, {[], [], {0, y}})

    {board_line |> Enum.reverse() |> List.to_tuple(), carts |> Enum.reverse()}
  end

  def do_parse_line(<<?>>> <> rest, {board_line, carts, {x, y}}) do
    acc = {[?- | board_line], [{:right, :left, {x, y}} | carts], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?<>> <> rest, {board_line, carts, {x, y}}) do
    acc = {[?- | board_line], [{:left, :left, {x, y}} | carts], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?^>> <> rest, {board_line, carts, {x, y}}) do
    acc = { [?| | board_line], [{:up, :left, {x, y}} | carts], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?v>> <> rest, {board_line, carts, {x, y}}) do
    acc = {[?| | board_line], [{:down, :left, {x, y}} | carts], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<ch::utf8>> <> rest, {board_line, carts, {x, y}}) do
    acc = {[ch | board_line], carts, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<>>, acc) do
    acc
  end

  def part2(args) do
  end
end
