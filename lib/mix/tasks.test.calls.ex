defmodule Mix.Tasks.Test.Calls do
  use Mix.Task

  @impl true
  def run(args) do
    # The `trace` flag must be enabled since monitor supports processing a
    # single test at a time
    args = ["--trace" | args]

    # Starts tracer and monitor
    ExUnitTracer.start!()

    # Executes test suite
    Mix.Task.run("test", args)
    Mix.Task.clear()

    # Waits for the traces to be processed
    {:ok, calls} = ExUnitTracer.await_suite()

    # Print :D
    IO.inspect(calls)
  end
end
