defmodule AdventOfCode2018.Day09 do
  import NimbleParsec

  require Circle

  def part1(input) do
    input
    |> marble_mania_input()
    |> high_score()
  end

  defp high_score({players_count, max_marble}) do
    circle = Circle.new |> Circle.put(0, 0)

    {_, scores} =
      1..max_marble
      |> Enum.reduce({circle, %{}}, fn marble, acc -> move(marble, acc, players_count) end)

    scores |> Enum.max_by(fn {_, score} -> score end) |> elem(1)
  end

  defp move(marble, {circle, scores}, player_count) when rem(marble, 23) == 0 do
    {seventh_value, new_circle} =
      circle
      |> Circle.shift(-7)
      |> Circle.get_and_delete_current()
    additional_score = marble + seventh_value
    player = rem(marble, player_count) + 1

    {new_circle, Map.update(scores, player, additional_score, &(&1 + additional_score))}
  end
  defp move(marble, {circle, scores}, _player_count) do
    new_circle =
      circle
      |> Circle.shift(1)
      |> Circle.put(marble, marble)

    {new_circle, scores}
  end

  def part2(args) do
  end

  defparsecp :marble_mania_parse_input,
             integer(min: 1)
             |> ignore(string(" players; last marble is worth "))
             |> integer(min: 1)
             |> ignore(string(" points"))

  defp marble_mania_input(input) do
    {:ok, [players_count, max_marble], _, _, _, _} = marble_mania_parse_input(input)
    {players_count, max_marble}
  end
end
