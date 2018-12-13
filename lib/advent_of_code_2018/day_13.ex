defmodule AdventOfCode2018.Day13 do
  def part1(file_stream) do
    {board, cards} =
      file_stream
      |> parse()

    # board
    # |> Tuple.to_list()
    # |> Enum.each(fn l -> IO.inspect(l, label: "board") end)

    # Stream.cycle([1])
    # |> Enum.reduce_while(cards, fn _, _ ->
    #   new_cards = tick(cards, board)
    #   case find_conflict(new_cards) do
    #     nil -> {:cont, new_cards}
    #     point -> {:halt, point}
    #   end
    # end)
    cards
    |> tick(board)
    |> IO.inspect(label: "1")
    |> tick(board)
    |> IO.inspect(label: "2")
    |> tick(board)
    |> IO.inspect(label: "3")
    |> tick(board)
    |> IO.inspect(label: "4")
    |> tick(board)
    |> IO.inspect(label: "5")
    |> tick(board)
    |> IO.inspect(label: "6")
    |> tick(board)
    |> IO.inspect(label: "7")
    |> tick(board)
    |> IO.inspect(label: "8")
    |> tick(board)
    |> IO.inspect(label: "9")
    |> tick(board)
    |> IO.inspect(label: "10")
    |> tick(board)
    |> IO.inspect(label: "11")
    |> tick(board)
    |> IO.inspect(label: "12")
    |> tick(board)
    |> IO.inspect(label: "13")
    |> tick(board)
    |> IO.inspect(label: "14")
    |> tick(board)
    |> IO.inspect(label: "15")
  end

  defp parse(file_stream) do
    {board, cards, _} =
      file_stream
      |> Enum.reduce({[], [], 0}, fn line, {board, cards, y} ->
        {board_line, line_cards} = parse_line(line, y)

        {[board_line | board], cards ++ line_cards, y + 1}
      end)

    {board |> Enum.reverse() |> List.to_tuple(), cards}
  end


  defp tick(cards, board) do
    new_cards =
      cards
      |> Enum.map(fn {_, _, {x, y}} = card ->
        point = next_board_point(card, board)
        move(card, point)
      end)
  end

  defp find_conflict(cards) do
    {_, conflicting} =
    Enum.reduce_while(cards, {MapSet.new, nil}, fn {_, _, point}, {acc, _} ->
      if MapSet.member?(acc, point),
        do: {:halt, {acc, point}},
        else: {:cont, {MapSet.put(acc, point), nil}}
    end)

    conflicting
  end

  defp next_board_point({:left, _, {x, y}}, board), do: board |> elem(y) |> elem(x - 1)
  defp next_board_point({:right, _, {x, y}}, board), do: board |> elem(y) |> elem(x + 1)
  defp next_board_point({:up, _, {x, y}}, board), do: board |> elem(y - 1) |> elem(x)
  defp next_board_point({:down, _, {x, y}}, board), do: board |> elem(y + 1) |> elem(x)

  defp next_intersection_move({_, :left, {x, y}}),          do: {:left,  :straight, {x - 1, y}}
  defp next_intersection_move({:left, :straight, {x, y}}),  do: {:left,  :right,    {x - 1, y}}
  defp next_intersection_move({:right, :straight, {x, y}}), do: {:right, :right,    {x + 1, y}}
  defp next_intersection_move({:up, :straight, {x, y}}),    do: {:up,    :right,    {x, y - 1}}
  defp next_intersection_move({:down, :straight, {x, y}}),  do: {:down,  :right,    {x, y + 1}}
  defp next_intersection_move({_, :right, {x, y}}),         do: {:right, :left,     {x + 1, y}}

  def move({current_move, _, {x, y}} = card, {true, true, true, true}) do
    next_intersection_move(card)
  end

  def move({:left, intersection_move, {x, y}}, {true, _, _, _}) do
    {:left, intersection_move, {x - 1, y}}
  end
  def move({:left, intersection_move, {x, y}}, {_, _, true, _}) do
    {:up, intersection_move, {x - 1, y}}
  end
  def move({:left, intersection_move, {x, y}}, {_, _, _, true}) do
    {:down, intersection_move, {x - 1, y}}
  end
  def move({:right, intersection_move, {x, y}}, {_, true, _, _}) do
    {:right, intersection_move, {x + 1, y}}
  end
  def move({:right, intersection_move, {x, y}}, {_, _, true, _}) do
    {:up, intersection_move, {x + 1, y}}
  end
  def move({:right, intersection_move, {x, y}}, {_, _, _, true}) do
    {:down, intersection_move, {x + 1, y}}
  end
  def move({:up, intersection_move, {x, y}}, {_, _, true, _}) do
    {:up, intersection_move, {x, y - 1}}
  end
  def move({:up, intersection_move, {x, y}}, {true, _, _, _}) do
    {:left, intersection_move, {x, y - 1}}
  end
  def move({:up, intersection_move, {x, y}}, {_, true, _, _}) do
    {:right, intersection_move, {x, y - 1}}
  end
  def move({:down, intersection_move, {x, y}}, {_, _, _, true}) do
    {:down, intersection_move, {x, y + 1}}
  end
  def move({:down, intersection_move, {x, y}}, {true, _, false, _}) do
    {:left, intersection_move, {x, y + 1}}
  end
  def move({:down, intersection_move, {x, y}}, {_, true, _, _}) do
    {:right, intersection_move, {x, y + 1}}
  end

  def parse_line(line, y) do
    {board_line, cards, _} = do_parse_line(line, {[], [], {0, y}})

    {board_line |> Enum.reverse() |> List.to_tuple(), cards}
  end

  # {left, right, up, down}
  def do_parse_line(<<?->> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, true, false, false} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?|>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{false, false, true, true} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?+>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, true, true, true} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  # /-
  # |
  def do_parse_line(<<?/, ?->> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{false, true, false, true} | board_line], cards, {x + 1, y}}
    do_parse_line(<<?->> <> rest, acc)
  end

  #  |
  # -/
  def do_parse_line(<<?/>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, false, true, false} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  # |
  # \-
  def do_parse_line(<<92, ?->> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{false, true, true, false} | board_line], cards, {x + 1, y}}
    do_parse_line(<<?->> <> rest, acc)
  end

  # -\
  #  |
  def do_parse_line(<<92>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, false, false, true} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?>>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, true, false, false} | board_line],
      [{:right, :left, {x, y}} | cards], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?<>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{true, true, false, false} | board_line],
      [{:left, :left, {x, y}} | cards], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?^>> <> rest, {board_line, cards, {x, y}}) do
    acc = {
      [{false, false, true, true} | board_line],
      [{:up, :left, {x, y}} | cards], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<?v>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{false, false, true, true} | board_line],
      [{:down, :left, {x, y}} | cards], {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<_::utf8>> <> rest, {board_line, cards, {x, y}}) do
    acc = {[{false, false, false, false} | board_line], cards, {x + 1, y}}
    do_parse_line(rest, acc)
  end

  def do_parse_line(<<>>, acc) do
    acc
  end

  def part2(args) do
  end
end
