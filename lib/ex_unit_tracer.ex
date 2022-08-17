defmodule ExUnitTracer do
  def start!(opts \\ []) do
    {:ok, monitor_pid} = GenServer.start_link(ExUnitTracer.Monitor, self(), name: ExUnitTracer.Monitor)

    init_trace(monitor_pid, opts)
    monitor_pid
  end

  def calls(pid_or_name \\ ExUnitTracer.Monitor) do
    GenServer.call(pid_or_name, :state).calls
  end

  def current_test(pid_or_name \\ ExUnitTracer.Monitor) do
    GenServer.call(pid_or_name, :state).current_test
  end

  def await_suite(pid_or_name \\ ExUnitTracer.Monitor) do
    GenServer.cast(pid_or_name, {:register, self()})

    receive do
      {:suite_finished, calls} -> {:ok, calls}
    end
  end

  defp init_trace(monitor, opts) do
    {mode, opts} = Keyword.pop(opts, :mode, :new_processes)
    opts = opts ++ [{:tracer, monitor}, :call]

    # match_spec = [{:_, [], [{:message, {{:cp, {:caller}}}}]}]
    match_spec = true
    :erlang.trace_pattern(:on_load, match_spec, [:global])
    :erlang.trace_pattern({:_, :_, :_}, match_spec, [:global])
    :erlang.trace(mode, true, opts)
  end
end
