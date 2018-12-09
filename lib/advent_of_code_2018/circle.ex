defmodule Circle do
  defstruct data: %{}, current: nil

  def new() do
    %Circle{}
  end

  @doc ~S"""
  Put value clockwise

  ## Examples
    iex> Circle.new() |> Circle.put(:a, 1)
    %Circle{data: %{a: {1, {:a, :a}}}, current: :a}

    iex> Circle.new() |> Circle.put(:a, 1) |> Circle.put(:b, 2) |> Circle.put(:c, 3)
    %Circle{data: %{a: {1, {:c, :b}}, b: {2, {:a, :c}}, c: {3, {:b, :a}}}, current: :c}
  """
  def put(%Circle{data: data}, key, value) when data == %{} do
    %Circle{data: %{key => {value, {key, key}}}, current: key}
  end
  def put(%Circle{data: data, current: current}, key, value) do
    {right, data} =
      Map.get_and_update(data, current, fn {value, {l, r}} ->
        {r, {value, {l, key}}}
      end)

    {left, data} =
      Map.get_and_update(data, right, fn {value, {l, r}} ->
        {l, {value, {key, r}}}
      end)

    data = Map.put(data, key, {value, {left, right}})

    %Circle{data: data, current: key}
  end

  @doc ~S"""
  Get current element with information about left and right neighbors.

  ## Examples
    iex> circle = Circle.new() |> Circle.put(:a, 1) |> Circle.put(:b, 2)
    iex> Circle.get_current(circle)
    {2, {:a, :a}}
  """
  def get_current(%Circle{data: data, current: current}) do
    Map.get(data, current)
  end


  @doc ~S"""
  Shift current element clocwise if `count` is positive, counter-clockwise if
  `count` is negative.

  ## Examples
    iex> circle = Circle.new() |> Circle.shift(2)
    %Circle{data: %{}, current: nil}

    iex> circle = Circle.new() |> Circle.put(:a, 1) |> Circle.put(:b, 2) |> Circle.put(:c, 3)
    iex> Circle.shift(circle, 2)
    %Circle{data: %{a: {1, {:c, :b}}, b: {2, {:a, :c}}, c: {3, {:b, :a}}}, current: :b}

    iex> circle = Circle.new() |> Circle.put(:a, 1) |> Circle.put(:b, 2) |> Circle.put(:c, 3)
    iex> Circle.shift(circle, -2)
    %Circle{data: %{a: {1, {:c, :b}}, b: {2, {:a, :c}}, c: {3, {:b, :a}}}, current: :a}
  """
  def shift(%Circle{current: nil} = circle, count) do
    circle
  end
  def shift(circle, 0) do
    circle
  end
  def shift(%Circle{data: data, current: current}, count) when count > 0 do
    {_, {_, right}} = Map.get(data, current)
    shift(%Circle{data: data, current: right}, count - 1)
  end
  def shift(%Circle{data: data, current: current}, count) when count < 0 do
    {_, {left, _}} = Map.get(data, current)
    shift(%Circle{data: data, current: left}, count + 1)
  end

  @doc ~S"""
  Delete current element, move current clockwise.

  ## Examples
    iex> Circle.new() |> Circle.delete_current()
    %Circle{data: %{}, current: nil}

    iex> Circle.new() |> Circle.put(:a, 1) |> Circle.delete_current()
    %Circle{data: %{}, current: nil}

    iex> Circle.new() |> Circle.put(:a, 1) |> Circle.put(:b, 2) |> Circle.delete_current()
    %Circle{data: %{a: {1, {:a, :a}}}, current: :a}
  """
  def delete_current(%Circle{data: data, current: nil}) do
    %Circle{data: data, current: nil}
  end
  def delete_current(%Circle{data: data, current: current}) do
    case Map.get_and_update(data, current, fn _ -> :pop end) do
      {{_, {^current, ^current}}, _} ->
        %Circle{data: %{}, current: nil}
      {{nil, _}, _} ->
        %Circle{data: data, current: current}
      {{_, {left, right}}, data_without_current} ->
        new_data =
          data_without_current
          |> Map.update!(left, fn {value, {old_left, _}} ->
            {value, {old_left, right}}
          end)
          |> Map.update!(right, fn {value, {_, old_right}} ->
            {value, {left, old_right}}
          end)
        %Circle{data: new_data, current: right}
    end
  end

  @doc ~S"""
  Get and delete current element.

  ## Example

    iex> Circle.new() |> Circle.put(:a, 1) |> Circle.get_and_delete_current()
    {1, %Circle{data: %{}, current: nil}}
  """
  def get_and_delete_current(circle) do
    {value, _} = get_current(circle)
    new_circle = delete_current(circle)

    {value, new_circle}
  end
end
