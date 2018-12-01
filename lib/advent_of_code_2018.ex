defmodule AdventOfCode2018 do
  @moduledoc """
  Documentation for AdventOfCode2018.
  """

  def input!(path) do
    File.stream!(path)
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list
  end
end
