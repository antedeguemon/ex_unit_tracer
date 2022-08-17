defmodule ExUnitTracer.Monitor do
  use GenServer

  @impl true
  def init(parent_pid) do
    initial_state = %{
      parent_pid: parent_pid,
      calls: %{},
      current_test: nil,
      finished_tests: []
    }

    {:ok, initial_state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:register, parent_pid}, state) do
    {:noreply, %{state | parent_pid: parent_pid}}
  end

  @impl true
  def handle_info(
        {:trace, _pid, :call, {ExUnit.EventManager, function, args}},
        %{parent_pid: parent_pid} = state
      ) do
    updated_state =
      case {function, args} do
        {:test_started, [_supervisor_pids, %ExUnit.Test{} = test]} ->
          %{state | current_test: test}

        {:test_finished, [_, %ExUnit.Test{} = test]} ->
          # TODO: notify(test_finished)
          %{state | current_test: nil, finished_tests: [test | state.finished_tests]}

        {:stop, _args} ->
          unless is_nil(parent_pid) do
            send(parent_pid, {:suite_finished, state.calls})
          end

          state

        _ ->
          state
      end

    {:noreply, updated_state}
  end

  def handle_info(
        {:trace, _pid, :call, {_module, _function, _args} = trace},
        %{current_test: current_test} = state
      )
      when not is_nil(current_test) do
    updated_calls =
      Map.update(state.calls, state.current_test, [trace], fn calls ->
        [trace | calls]
      end)

    {:noreply, %{state | calls: updated_calls}}
  end

  def handle_info(_event, state) do
    {:noreply, state}
  end
end
