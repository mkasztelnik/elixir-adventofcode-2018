defmodule AdventOfCode2018.Day03 do
  @pattern ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/

  def part1(file_stream) do
      file_stream
      |> Stream.map(&extract_claim/1)
      |> Stream.flat_map(&to_fields/1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.count(fn
        {_, 1} -> false
        {_, _} -> true
      end)
  end

  defp to_fields(%{"left" => l, "top" => t, "height" => h, "width" => w}) do
    for x <- 1..w, y <- 1..h, do: {x + l, y + t}
  end

  defp extract_claim(line) do
    %{"left" => l, "top" => t, "height" => h, "width" => w, "id"  => id} =
      Regex.named_captures(@pattern, line)

    %{
      "left" => String.to_integer(l),
      "top" => String.to_integer(t),
      "height" => String.to_integer(h),
      "width" => String.to_integer(w),
      "id" => id
    }
  end

  def part2(file_stream) do
    plans = file_stream |> Enum.map(&extract_claim/1)

    plans
    |> Enum.find(fn plan ->
      Enum.all?(plans, fn candidate ->
        plan == candidate || disjoint?(plan, candidate)
      end)
    end)
    |> unique
  end

  defp disjoint?(%{"left" => ll, "top" => lt, "height" => lh, "width" => lw},
                 %{"left" => rl, "top" => rt, "height" => rh, "width" => rw}) do
    ll + lw <= rl || lt + lh <= rt || ll >= rl + rw || lt >= rt + rh
  end

  def unique(%{"id" => id}), do: String.to_integer(id)
end
