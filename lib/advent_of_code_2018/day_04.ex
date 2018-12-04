defmodule AdventOfCode2018.Day04 do
  @date_and_action ~r/\[(?<date>[^\]]+)\] (?<event>.+)/
  @guard_id ~r/Guard #(?<id>\d+)/

  def part1(file_stream) do
    file_stream
    |> grouped_sleep_time()
    |> strategy1()
  end

  defp strategy1(grouped_sleep_time) do
    {id, {_, sleep_intervals}} =
      Enum.max_by(grouped_sleep_time, fn {_, {count, _}} -> count end)

    {minute, _} = max_frequent(sleep_intervals)
    id * minute
  end

  def part2(file_stream) do
    file_stream
    |> grouped_sleep_time()
    |> strategy2()
  end

  defp strategy2(grouped_sleep_time) do
    {id, {minute, _}} =
      grouped_sleep_time
      |> Enum.map(fn {id, {_, sleep_intervals}} ->
        {id, max_frequent(sleep_intervals)}
      end)
      |> Enum.max_by(fn {_, {_, count}} -> count end)

    id * minute
  end

  defp max_frequent(sleep_intervals) do
    sleep_intervals
    |> Enum.flat_map(fn {from, to} ->
      for x <- from..to, do: x
    end)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)
    |> Enum.max_by(fn {_, count} -> count end)
  end

  def grouped_sleep_time(file_stream) do
    file_stream
    |> Stream.map(&date_action_touple/1)
    |> Enum.sort(fn {x, _}, {y, _} ->
      case DateTime.compare(x, y) do
        :lt -> true
        _ -> false
      end
    end)
    |> group()
  end

  defp group(list) do
    group(nil, list, %{})
  end
  defp group(_, [{_, {:guard, id}} | tail], acc) do
    group(id, tail, acc)
  end
  defp group(id, [{from, :falls_asleep} | tail], acc) do
    group(id, tail, from, acc)
  end
  defp group(_, [], acc) do
    acc
  end
  defp group(id, [{to_date, :wakes_up} | tail], from_date, acc) do
    from = from_date.minute
    to = to_date.minute - 1
    new_acc = Map.update(acc, id, {to - from, [{from, to}]}, fn {count, list} ->
      {count + to - from, [{from, to} | list]}
    end)
    group(id, tail, new_acc)
  end

  defp date_action_touple(line) do
    %{"date" => date_string, "event" => event} =
      Regex.named_captures(@date_and_action, line)

    {
      to_date(date_string),
      event |> String.trim() |> action()
    }
  end

  defp to_date(date) do
    {:ok, parsed_date, _} = DateTime.from_iso8601(date <> ":00Z")
    parsed_date
  end

  defp action("falls asleep"), do: :falls_asleep
  defp action("wakes up"), do: :wakes_up
  defp action(event) do
    %{"id" => id} = Regex.named_captures(@guard_id, event)
    {:guard, String.to_integer(id)}
  end
end
