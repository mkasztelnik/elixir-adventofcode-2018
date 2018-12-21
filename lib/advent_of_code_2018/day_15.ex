defmodule AdventOfCode2018.Day15 do
  def part1(file_stream) do
    {board, players, width, height} = parse(file_stream)

    {_, remaining_players, rounds_count} =
    Stream.cycle([1])
    |> Enum.reduce_while({board, players, 1}, fn _, {board, players, count} ->
      {new_board, new_players, status} =
        round(board, players)
        |> print(width, height, count)

      case status do
        :cont ->
          if finished?(new_players),
            do: {:halt, {new_board, new_players, count}},
            else: {:cont, {new_board, new_players, count + 1}}
        :victory ->
          {:halt, {new_board, new_players, count - 1}}
      end
    end)

    hp_count = Enum.reduce(remaining_players, 0, fn {_, {_, hp}}, acc ->  acc + hp end)

    IO.puts("------------------------------------------------------")
    IO.puts("#{rounds_count} * #{hp_count} = #{hp_count * rounds_count}")

    hp_count * rounds_count
  end

  defp round(board, players) do
    players_map = Map.new(players)

    players
    |> sort_players()
    |> Enum.reduce_while({board, players_map, nil}, fn player, {board, players_map, _} = acc ->
      case still_alive?(players_map, player) do
        true ->
          {_, _, status} = result =
            {board, players_map, player}
            |> move()
            |> attack()

          case status do
            :cont -> {:cont, result}
            :victory -> {:halt, result}
          end
        false ->
          {:cont, acc}
      end
    end)
  end

  defp move_candidate(board, players, {point, _} = player) do
    case targets(board, players, player) do
      [] ->
        nil
      targets ->
        enemy = enemy(player)
        if Enum.any?(neighboars_points(point), fn sp -> Map.get(board, sp) == enemy end) do
          nil
        else
          starting_points =
            neighboars_points(point)
            |> Enum.filter(fn candidate -> Map.get(board, candidate) == ?. end)
            |> Enum.map(fn candidate -> {candidate, candidate} end)

          optimal_move(board, starting_points, targets, new_visited(MapSet.new, starting_points))
        end
    end
  end

  defp next_possible_points(board, visited, {direction, point}) do
    neighboars_points(point)
    |> Enum.reject(fn candidate -> MapSet.member?(visited, candidate) end)
    |> Enum.filter(fn candidate -> Map.get(board, candidate) == ?. end)
    |> Enum.map(fn candidate -> {direction, candidate} end)
  end

  defp optimal_move(_board, [], _targets, _visited) do
    nil
  end
  defp optimal_move(board, [{direction, point} = candidate | rest], targets, visited) do
    if point in targets do
      direction
    else
      next_possible_points = next_possible_points(board, visited, candidate)

      optimal_move(board, rest ++ next_possible_points, targets,
                   new_visited(visited, next_possible_points))
    end
  end

  defp new_visited(visited, next_possible_points) do
    only_points = Enum.map(next_possible_points, fn {_, point} -> point end)
    MapSet.union(visited, MapSet.new(only_points))
  end

  defp finished?(players) do
    goblin = Enum.find(players, fn {_, {type, _}} -> type == ?G end)
    elve = Enum.find(players, fn {_, {type, _}} -> type == ?E end)

    goblin == nil || elve == nil
  end

  defp move({board, players_map, {point, {type, hp}} = player}) do
    case move_candidate(board, players_map, player) do
      nil ->
        {board, players_map, player}
      new_point ->
        new_board = board |> Map.put(point, ?.) |> Map.put(new_point, type)
        new_players_map = players_map |> Map.delete(point) |> Map.put(new_point, {type, hp})

        {new_board, new_players_map, {new_point, {type, hp}}}
    end
  end

  defp targets(board, players, player) do
    enemy = enemy(player)
    players
    |> Enum.flat_map(fn {point, {type, _}} ->
      case type do
        ^enemy ->
          neighboars_points(point)
          |> Enum.filter(fn point -> Map.get(board, point) == ?. end)
        _ -> []
      end
    end)
    |> MapSet.new
  end


  defp attack({board, players_map, player}) do
    case finished?(players_map) do
      true -> {board, players_map, :victory}
      false -> do_attack({board, players_map}, player)
    end
  end

  defp still_alive?(players_map, {point, {type, _}}) do
    case Map.get(players_map, point) do
      nil -> false
      {^type, _} -> true
      _ -> false
    end
  end

  defp do_attack({board, players_map}, player) do
    case attack_candidate(board, players_map, player) do
      nil -> {board, players_map, :cont}
      target -> perform_attack({board, players_map}, target)
    end
  end

  defp perform_attack({board, players_map}, target) do
    {type, health}  = Map.get(players_map, target)

    if health <= 3,
      do: {Map.put(board, target, ?.), Map.delete(players_map, target), :cont},
      else: {board, Map.put(players_map, target, {type, health - 3}), :cont}
  end

  defp attack_candidate(_board, players_map, {{x, y}, _} = player) do
    enemy = enemy(player)

    left =  player_health(players_map, enemy, {x - 1, y})
    right = player_health(players_map, enemy, {x + 1, y})
    up =    player_health(players_map, enemy, {x, y - 1})
    down =  player_health(players_map, enemy, {x, y + 1})

    min_candidate([{:left, left}, {:right, right}, {:up, up}, {:down, down}], {x, y})
  end

  defp player_health(players_map, type, point) do
    case Map.get(players_map, point) do
      {^type, health} -> health
      _ -> nil
    end
  end


  defp neighboars_points({x, y}) do
    # up, left, right, down
    [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]
  end

  defp min_candidate(candidates, {x, y}) do
    ordered =
      candidates
      |> Enum.reject(fn {_, v} -> v == nil end)
      |> Enum.sort(fn {_, v1}, {_, v2} -> v1 <= v2 end)

    directions_candidate =
      case ordered do
        [] ->
          nil
        [{_, min} | _] = ordered ->
          Enum.reduce(ordered, [], fn {direction, value}, acc ->
            if value == min, do: [direction | acc], else: acc
          end)
      end

    case directions_candidate do
      nil -> nil
      directions ->
        cond do
          :up in directions  -> {x, y - 1}
          :left in directions -> {x - 1, y}
          :right in directions-> {x + 1, y}
          :down in directions-> {x, y + 1}
          true -> nil
        end
    end
  end

  defp enemy({_, {type, _}}), do: if type == ?E, do: ?G, else: ?E

  defp print({board, players, status}, width, height, label) do
    IO.puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{label} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #{status}"

    for y <- 0..height,
        x <-0..width do
      IO.write([Map.get(board, {x, y})])
      if x == width, do: print_players(players, y)
    end

    {board, players, status}
  end

  defp print_players(players, y) do
    IO.write("  ")
    players
    |> Enum.filter(fn {{_, player_y}, _} -> player_y == y end)
    |> Enum.sort(fn {{x1, _}, _}, {{x2, _}, _} -> x1 <= x2 end)
    |> Enum.each(fn {_, {type, hp}} ->
      IO.write("#{[type]}#{hp} ")
    end)
    IO.write("\n")
  end

  defp sort_players(players) do
    players
    |> Enum.sort(fn {{x1, y1}, _}, {{x2, y2}, _} ->
      y1 < y2 || (y1 == y2 && x1 <= x2)
    end)
  end

  defp parse(file_stream) do
    {board, players, y_max, x_max} =
      file_stream
      |> Enum.reduce({%{}, [], 0, 0}, fn line, {board, players, y, _} ->
        {new_board, new_players, x_max} =
          line
          |> String.trim()
          |> String.to_charlist()
          |> Enum.reduce({board, players, 0}, fn ch, {board, players, x} ->
            new_players =
              case ch do
                ?G -> [{{x,y}, {?G, 200}} | players]
                ?E -> [{{x,y}, {?E, 200}} | players]
                _  -> players
              end
            {Map.put(board, {x, y}, ch), new_players, x + 1}
          end)
        {new_board, new_players, y + 1, x_max}
      end)

    {board, players, x_max - 1, y_max - 1}
  end

  def part2(args) do
  end
end
