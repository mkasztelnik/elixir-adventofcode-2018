defmodule Assembly do
  defstruct dependencies: %{}, finished: MapSet.new, in_progress: %{}

  def new(dependencies) do
    %Assembly{dependencies: dependencies}
  end

  def order(assembly) do
    do_order(assembly, [])
  end

  def time(assembly, base_time, worker_count) do
    do_time(assembly, base_time, worker_count, 0)
  end

  defp do_time(%Assembly{dependencies: []}, _, _, time) do
    time
  end
  defp do_time(assembly, base_time, worker_count, time) do
    in_progress = schedule(assembly, base_time, worker_count)
    {work_time, finished, new_in_progress} = work(in_progress)

    new_dependencies =
      assembly.dependencies
      |> Enum.reject(fn {job, _} -> MapSet.member?(finished, job) end)

    new_finished = MapSet.union(assembly.finished, finished)

    new_assembly = %{assembly | dependencies: new_dependencies,
                                finished: new_finished,
                                in_progress: new_in_progress}

    do_time(new_assembly, base_time, worker_count, time + work_time)
  end

  def work(jobs) do
    {_, min_time} =
      jobs
      |> Enum.min_by(fn {_, time} -> time end)

    {new_in_progress, jobs_done} =
      jobs
      |> Enum.reduce({%{}, []}, fn {job, time}, {in_progress, done} ->
        case time - min_time do
          0         -> {in_progress, [job | done]}
          time_left -> {Map.put(in_progress, job, time_left), done}
        end
      end)

    {min_time, MapSet.new(jobs_done), new_in_progress}
  end

  defp schedule(%Assembly{in_progress: in_progress} = assembly, base_time, worker_count) do
    in_progress_count = assembly.in_progress |> Map.keys |> length
    times = worker_count - in_progress_count
    in_progress_init = in_progress |> Map.keys |> MapSet.new

    Stream.cycle([1])
    |> Enum.reduce_while({in_progress_init, [], times}, fn
      _, {_, acc, 0} ->
        {:halt, Enum.reverse(acc)}
      _, {in_progress, acc, times} ->
        case next(assembly, in_progress) do
          {:ok, next} -> {:cont, {MapSet.put(in_progress, next), [next | acc], times - 1}}
          :halt       -> {:halt, Enum.reverse(acc)}
        end
    end)
    |> Enum.map(fn job -> {job, time(job, base_time)} end)
    |> Map.new
    |> Map.merge(in_progress)
  end

  @cost_diff ?A
  defp time(task, a_job_cost) do
    task - @cost_diff + a_job_cost
  end

  defp do_order(%Assembly{dependencies: dependencies}, acc) when dependencies == %{} do
    acc |> Enum.reverse |> List.to_string
  end
  defp do_order(%Assembly{dependencies: dependencies, finished: finished} = assembly, acc) do
    {:ok, next} = next(assembly)

    do_order(%{assembly | dependencies: Map.delete(dependencies, next),
                          finished: MapSet.put(finished, next)},
            [next | acc])
  end

  defp next(%Assembly{dependencies: dependencies, finished: finished}, in_progress \\ MapSet.new) do
    candidates =
      dependencies
      |> Enum.filter(fn {job, dependent} ->
        MapSet.subset?(dependent, finished) &&
          !MapSet.member?(in_progress, job)
      end)
      |> Enum.sort(fn {first, _}, {second, _} -> first <= second end)

    case candidates do
      [{next, _} | _] -> {:ok, next}
      [] -> :halt
    end
  end
end

defmodule AdventOfCode2018.Day07 do
  def part1(file_stream) do
    file_stream
    |> to_depenceny_graph()
    |> Assembly.new()
    |> Assembly.order()
  end

  def part2(file_stream, base_time, worker_count) do
    file_stream
    |> to_depenceny_graph()
    |> Assembly.new()
    |> Assembly.time(base_time, worker_count)
  end

  defp to_depenceny_graph(file_stream) do
    file_stream
    |> Enum.reduce(%{}, fn line, acc ->
      {job, dependent} = parse(line)

      acc
      |> Map.update(job, MapSet.new([dependent]), &(MapSet.put(&1, dependent)))
      |> Map.update(dependent, MapSet.new, &(&1))
    end)
  end

  def parse("Step " <> <<dependent::utf8>> <> " must be finished before step " <>
            <<job::utf8>> <> <<_::binary>>) do
    {job, dependent}
  end
end
