# ExUnitTracer

An example project about tracing inside ExUnit. 

It contains examples of:
- [Extracting functions executed during tests](/test/ex_unit_tracer_test.exs#L5)
- [Fetching test context without directly accessing the test context](/test/ex_unit_tracer_test.exs#L18)
- [Managing the test suite control flow](/lib/ex_unit_tracer.ex#L17)

## Example

You may run the [`mix test.calls`](/lib/mix/tasks.test.calls.ex) task, which
will execute your project's test suite and print all functions called during
test runtime.

```elixir
$ mix test.calls

%{
  %ExUnit.Test{
    name: :"test calls fetches calls",
    tags: %{
      test: :"test calls fetches calls",
      # ...
    },
    # ...
  } => [
    {Enum, :reverse, [[]]},
    {:ets, :take, [ExUnit.OnExitHandler, #PID<0.167.0>]},
    {ExUnit.OnExitHandler, :run, [#PID<0.167.0>, :infinity]},
    # ... all calls within `test calls fetches calls`
  ]
}
```
