# ExUnitTracer

Example project about tracing inside ExUnit. 

It may be useful for:
- Extracting functions executed during tests
- Fetching test context without directly accessing the test context
- Managing the test suite control flow

## Example

You can run the `mix test.calls` task, which will execute your project's test
suite and print all called functions.

```iex
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
