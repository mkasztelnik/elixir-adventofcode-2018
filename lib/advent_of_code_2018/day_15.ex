defmodule AdventOfCode2018.Day15 do
  def part1(file_stream) do
    {_, remaining_players, rounds_count} =
      file_stream
      |> parse()
      |> play()

    hp_count = hp_count(remaining_players)

    IO.puts("------------------------------------------------------")
    IO.puts("#{rounds_count} * #{hp_count} = #{hp_count * rounds_count}")

    hp_count * rounds_count
  end

  def part2(file_stream) do
    {board, players, width, height} = parse(file_stream)
    # elves_count = Enum.count(players, fn {_, {_, type, _, _}} -> type == ?E end)
    # from_to = {3, 200}

    # {force, remaining_players, rounds_count} =
    # Stream.cycle([1])
    # |> Enum.reduce_while({from_to, {nil, nil}}, fn _, {{from, to}, {win_players, round}} ->
    #   case {from, to} do
    #     {val, val} ->
    #       {:halt, {val, win_players, round}}
    #     _ ->
    #       middle = from + div(to - from, 2)
    #       new_players = set_elves_impact_force(players, middle)
    #       {_, remaining_players, rounds_count} =
    #         play({board, new_players, width, height})
    #
    #       if elves_win?(remaining_players, elves_count) do
    #         if middle - 1 == from,
    #           do: {:halt, {middle, remaining_players, rounds_count}},
    #         else: {:cont, {{from, middle}, {remaining_players, rounds_count}}}
    #       else
    #         if middle + 1 == to,
    #           do: {:halt, {to, win_players, round}},
    #         else: {:cont, {{middle, to}, {win_players, round}}}
    #       end
    #   end
    # end)
    #
    new_players = set_elves_impact_force(players, 19)
    {_, remaining_players, rounds_count} =
      {board, new_players, width, height}
      |> play()

    hp_count = hp_count(remaining_players)

    IO.puts("------------------------------------------------------")
    IO.puts("#{rounds_count} * #{hp_count} = #{hp_count * rounds_count}")
    # IO.puts("#{rounds_count} * #{hp_count} = #{hp_count * rounds_count} (elve force #{force})")

    hp_count * rounds_count
  end

  defp hp_count(remaining_players) do
    Enum.reduce(remaining_players, 0, fn {_, {_, _, hp, _}}, acc ->  acc + hp end)
  end

  defp elves_win?(remaining_players, elves_count) do
    !Enum.any?(remaining_players, fn {_, {_, type, _, _}} -> type == ?G end) &&
      Enum.count(remaining_players) == elves_count
  end

  defp set_elves_impact_force(players, impact_force) do
    players
    |> Enum.map(fn
      {point, {uid, ?E, hp, _}} -> {point, {uid, ?E, hp, impact_force}}
      goblin -> goblin
    end)
  end

  defp play({board, players, width, height}) do
    # Stream.cycle([1])
    1..30
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
  end

  defp round(board, players) do
    players_map = Map.new(players)

    players
    |> sort_players()
    |> IO.inspect(label: "Sorted players")
    |> Enum.reduce_while({board, players_map, nil}, fn player, {board, players_map, _} = acc ->
      case still_alive?(players_map, player) do
        true ->
          {_, new_players_map, status} = result =
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
      candidate
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
    goblin = Enum.find(players, fn {_, {_, type, _, _}} -> type == ?G end)
    elve = Enum.find(players, fn {_, {_, type, _, _}} -> type == ?E end)

    goblin == nil || elve == nil
  end

  defp move({board, players_map, {point, {uid, type, _, _}} = player}) do
    case move_candidate(board, players_map, player) do
      nil ->
        {board, players_map, player}
      {new_point, target} ->
        IO.puts("#{uid} move to #{inspect new_point} (target #{inspect target})")
        new_board = board |> Map.put(point, ?.) |> Map.put(new_point, type)
        player_data = Map.get(players_map, point)
        new_players_map = players_map |> Map.delete(point) |> Map.put(new_point, player_data)

        {new_board, new_players_map, {new_point, player_data}}
    end
  end

  defp targets(board, players, player) do
    enemy = enemy(player)
    players
    |> Enum.flat_map(fn {point, {_, type, _, _}} ->
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

  defp still_alive?(players_map, {point, {uid, type, _, _}}) do
    case Map.get(players_map, point) do
      nil -> false
      {^uid, ^type, _, _} -> true
      _ -> false
    end
  end

  defp do_attack({board, players_map}, {_, {_, _, _, force}} = player) do
    case attack_candidate(board, players_map, player) do
      nil -> {board, players_map, :cont}
      target -> perform_attack({board, players_map}, player, target)
    end
  end

  defp perform_attack({board, players_map}, {_, {player_uid, _, _, demage}}, target) do
    {uid, type, health, force}  = Map.get(players_map, target)
    IO.puts("#{player_uid} is performing attack (with #{demage} demage) on #{uid} #{inspect target} (#{health - demage} hp remaining)")

    if health <= demage,
      do: {Map.put(board, target, ?.), Map.delete(players_map, target), :cont},
      else: {board, Map.put(players_map, target, {uid, type, health - demage, force}), :cont}
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
      {_, ^type, health, _} -> health
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

  defp enemy({_, {_, type, _, _}}), do: if type == ?E, do: ?G, else: ?E

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
    |> Enum.each(fn {_, {_, type, hp, _}} ->
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
    {board, players, y_max, x_max, _, _} =
      file_stream
      |> Enum.reduce({%{}, [], 0, 0, 0, 0}, fn line, {board, players, y, _, g, e} ->
        {new_board, new_players, x_max, new_g, new_e} =
          line
          |> String.trim()
          |> String.to_charlist()
          |> Enum.reduce({board, players, 0, g, e}, fn ch, {board, players, x, g, e} ->
            {new_players, new_g, new_e} =
              case ch do
                ?G -> {[{{x,y}, {"Goblin #{g}", ?G, 200, 3}} | players], g + 1, e}
                ?E -> {[{{x,y}, {"Elf #{e}", ?E, 200, 3}} | players], g, e + 1}
                _  -> {players, g, e}
              end
            {Map.put(board, {x, y}, ch), new_players, x + 1, new_g, new_e}
          end)
        {new_board, new_players, y + 1, x_max, new_g, new_e}
      end)

    {board, players, x_max - 1, y_max - 1}
  end

  defp uid do
    Integer.to_string(:rand.uniform(4294967296), 32)
  end
end
