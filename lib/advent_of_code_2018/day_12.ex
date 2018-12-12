defmodule AdventOfCode2018.Day12 do
  def part1(file_stream) do
    {initial_state, rules} = parse(file_stream)

    {result, shift} =
      Enum.reduce(1..20, {initial_state, 0}, fn _, acc -> tick(acc, rules) end)

    {sum, _} =
      Enum.reduce(result, {0, shift}, fn
        ?#, {count, shift} -> {count + shift, shift + 1}
        _, {count, shift} -> {count, shift + 1}
      end)

    sum
  end

  defp tick({state, shift}, rules) do
    {[?., ?. | do_tick([?., ?., ?., ?.| state], rules)], shift - 4}
  end

  defp do_tick([x1, x2, x3, x4, x5 | _] = [_ | tail], rules) do
    [Map.get(rules, {x1, x2, x3, x4, x5}, ?.) | do_tick(tail, rules)]
  end
  defp do_tick([x1, x2, x3, x4] = [_ | tail], rules) do
    [Map.get(rules, {x1, x2, x3, x4, ?.}, ?.) | do_tick(tail, rules)]
  end
  defp do_tick([x1, x2, x3] = [_ | tail], rules) do
    [Map.get(rules, {x1, x2, x3, ?., ?.}, ?.) | do_tick(tail, rules)]
  end
  defp do_tick([x1, x2] = [_ | tail], rules) do
    [Map.get(rules, {x1, x2, ?., ?., ?.}, ?.) | do_tick(tail, rules)]
  end
  defp do_tick([x1], rules) do
    [Map.get(rules, {x1, ?., ?., ?., ?.}, ?.)]
  end

  defp parse(file_stream) do
    file_stream
    |> Enum.reduce({nil, %{}}, &parse_line/2)
  end

  defp parse_line(<<x1::utf8, x2::utf8, x3::utf8, x4::utf8, x5::utf8>> <> " => " <> <<val::utf8>> <> _,
                  {initial_state, rules}) do
    {initial_state, Map.put(rules, {x1, x2, x3, x4, x5}, val)}
  end

  defp parse_line("initial state: " <> rest, {_, rules}) do
    {rest |> String.trim() |> String.to_charlist(), rules}
  end
  defp parse_line(_, acc) do
    acc
  end


  def part2(args) do
  end
end
