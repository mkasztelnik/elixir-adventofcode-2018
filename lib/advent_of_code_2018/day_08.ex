defmodule AdventOfCode2018.Day08 do
  def part1(list_of_numbers_string) when is_binary(list_of_numbers_string) do
    list_of_numbers_string
    |> to_number_list
    |> tree
    |> metadata_sum
  end

  def part2(list_of_numbers_string) do
    list_of_numbers_string
    |> to_number_list
    |> tree
    |> node_value
  end

  defp node_value({metadata, []}) do
    Enum.sum(metadata)
  end
  defp node_value({metadata, children}) do
    metadata
    |> Enum.map(fn
      0 ->
        0
      index ->
        case Enum.at(children, index - 1) do
          nil -> 0
          child -> node_value(child)
        end
    end)
    |> Enum.sum
  end

  defp to_number_list(list_of_numbers_string) when is_binary(list_of_numbers_string) do
    list_of_numbers_string
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defp metadata_sum({metadata, []}) do
    Enum.sum(metadata)
  end
  defp metadata_sum({metadata, children}) do
    children_metadata_sum =
      children
      |> Enum.map(&metadata_sum/1)
      |> Enum.sum

    Enum.sum(metadata) + children_metadata_sum
  end

  defp tree(numbers_list) do
    numbers_list
    |> to_tree
    |> elem(0)
  end
  defp to_tree([0, metadata_count | tail]) do
    {metadata, rest} = Enum.split(tail, metadata_count)
    {{metadata, []}, rest}
  end
  defp to_tree([children_count, metadata_count | tail]) do
    {children, rest} =
      1..children_count
      |> Enum.reduce({[], tail}, fn _, {children, tail_acc} ->
        {new_child, rest} = to_tree(tail_acc)
        {[new_child | children], rest}
      end)
    {metadata, new_rest} = Enum.split(rest, metadata_count)

    {{metadata, Enum.reverse(children)}, new_rest}
  end
end
