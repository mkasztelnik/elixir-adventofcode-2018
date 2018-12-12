defmodule AdventOfCode2018.Day12 do
  def part1(file_stream) do
    simulate(file_stream, 20)
  end

  def part2(file_stream) do
    simulate(file_stream, 50_000_000_000)
  end

  def simulate(file_stream, generations_count) do
    {initial_state, rules} = parse(file_stream)

    {result, shift} =
      Enum.reduce_while(generations_count..1, {initial_state, 0}, fn i, {state, shift} = acc ->
        {new_state, new_shift} = new_acc = tick(acc, rules)

        if new_state == state,
          do: {:halt, {new_state, new_shift + (new_shift - shift) * (i - 1)}},
          else: {:cont, new_acc}
      end)

    {sum, _} =
      Enum.reduce(result, {0, shift}, fn
        ?#, {count, shift} -> {count + shift, shift + 1}
        _, {count, shift} -> {count, shift + 1}
      end)

    sum
  end

  defp tick(state_and_shift, rules) do
    {state, shift} = prepare(state_and_shift)
    {[?., ?. | do_tick(state, rules)], shift}
  end

  defp prepare({[?., ?., ?., ?., ?. | _] = [_ | tail], shift}), do: prepare({tail, shift + 1})
  defp prepare({[?# | _] = state, shift}), do: {[?., ?., ?., ?. | state], shift - 4}
  defp prepare({[?., ?# | _] = state, shift}), do: {[?., ?., ?. | state], shift - 3}
  defp prepare({[?., ?., ?# | _] = state, shift}), do: {[?., ?. | state], shift - 2}
  defp prepare({[?., ?., ?., ?# | _] = state, shift}), do: {[?. | state], shift - 1}
  defp prepare({[?., ?., ?., ?. | _] = state, shift}), do: {state, shift}

  defp do_tick([?., ?., ?., ?., ?.], _) do
    []
  end

  defp do_tick([?., ?., ?., ?.], _) do
    []
  end

  defp do_tick([?., ?., ?.], _) do
    []
  end

  defp do_tick([?., ?.], _) do
    []
  end

  defp do_tick([?.], _) do
    []
  end

  defp do_tick([x1, x2, x3, x4, x5 | _] = [_ | tail], rules) do
    [val(rules, {x1, x2, x3, x4, x5}) | do_tick(tail, rules)]
  end

  defp do_tick([x1, x2, x3, x4] = [_ | tail], rules) do
    [val(rules, {x1, x2, x3, x4, ?.}) | do_tick(tail, rules)]
  end

  defp do_tick([x1, x2, x3] = [_ | tail], rules) do
    [val(rules, {x1, x2, x3, ?., ?.}) | do_tick(tail, rules)]
  end

  defp do_tick([x1, x2] = [_ | tail], rules) do
    [val(rules, {x1, x2, ?., ?., ?.}) | do_tick(tail, rules)]
  end

  defp do_tick([x1], rules) do
    [val(rules, {x1, ?., ?., ?., ?.})]
  end

  defp val(rules, pots) do
    if MapSet.member?(rules, pots), do: ?#, else: ?.
  end

  defp parse(file_stream) do
    Enum.reduce(file_stream, {nil, MapSet.new()}, &parse_line/2)
  end

  defp parse_line(
         <<x1::utf8, x2::utf8, x3::utf8, x4::utf8, x5::utf8>> <> " => #" <> _,
         {initial_state, rules}
       ) do
    {initial_state, MapSet.put(rules, {x1, x2, x3, x4, x5})}
  end

  defp parse_line("initial state: " <> rest, {_, rules}) do
    {rest |> String.trim() |> String.to_charlist(), rules}
  end

  defp parse_line(_, acc) do
    acc
  end
end
