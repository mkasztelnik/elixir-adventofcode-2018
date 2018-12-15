defmodule AdventOfCode2018.Day14 do
  def part1(recipies, nr) do
    {recipies_map, count} = recipies_map(recipies)
    Stream.cycle([1])
    |> Enum.reduce_while({recipies_map, 0, 1, count}, fn _, acc ->
      {new_recipies, _, _, count} = new_acc = make(acc)

      case count >= (nr + 10) do
        true ->
          scores =
            Enum.reduce((nr + 9)..nr, [], fn i, acc ->
              [Map.get(new_recipies, i) | acc]
            end)
          {:halt, scores}
        false ->
          {:cont, new_acc}
      end
    end)
  end

  def part2(recipies, sequence) do
    reversed_sequence = Enum.reverse(sequence)
    {recipies_map, count} = recipies_map(recipies)

    Stream.cycle([1])
    |> Enum.reduce_while({recipies_map, 0, 1, count}, fn _, acc ->
      {new_recipies, _, _, count} = new_acc = make(acc)

      case sequence_start(reversed_sequence, new_recipies, count) do
        nil -> {:cont, new_acc}
        sequence_start -> {:halt, sequence_start + 1}
      end
    end)
  end

  defp sequence_start([head | tail], recipies, count) do
    cond do
      Map.get(recipies, count - 1) == head ->
        do_sequence_start(tail, recipies, count - 2)
      Map.get(recipies, count - 2) == head ->
        do_sequence_start(tail, recipies, count - 3)
      true ->
        nil
    end
  end

  defp do_sequence_start([], _, index) do
    index
  end
  defp do_sequence_start([head | tail], recipies, index) do
    case Map.get(recipies, index) do
      ^head -> do_sequence_start(tail, recipies, index - 1)
      _ -> nil
    end
  end

  defp recipies_map(recipies) do
    Enum.reduce(recipies, {%{}, 0}, fn val, {map, i} ->
      {Map.put(map, i, val), i + 1}
    end)
  end

  defp make({recipies, first, second, count}) do
    first_value = Map.get(recipies, first)
    second_value = Map.get(recipies, second)

    {new_recipies, new_count} =
      case Integer.digits(first_value + second_value) do
        [v1, v2] ->
          {recipies |> Map.put(count, v1) |> Map.put(count + 1, v2), count + 2}
        [v1]     ->
          {recipies |> Map.put(count, v1), count + 1}
      end

    {
      new_recipies,
      rem(first + first_value + 1, new_count),
      rem(second + second_value + 1, new_count),
      new_count
    }
  end
end
