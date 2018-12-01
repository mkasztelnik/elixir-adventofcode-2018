defmodule AdventOfCode2018.Day01 do
  def part1(args) do
    args |> Enum.map(&parse/1) |> Enum.sum
  end

  defp parse(value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> 0
    end
  end

  def part2(args) do
    members = MapSet.put(MapSet.new, 0)
    Stream.cycle(args)
    |> Stream.map(&parse/1)
    |> Stream.transform({members, 0}, fn change, {members, frequency} ->
      current = frequency + change
      if MapSet.member?(members, current) do
        send(self(), current)
        {:halt, current}
      else
        {[], {MapSet.put(members, current), current}}
      end
    end)
    |> Stream.run

    receive do
      x -> x
    end
  end
end
