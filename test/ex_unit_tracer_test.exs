defmodule ExUnitTracer.Test do
  use ExUnit.Case, async: false

  describe "calls" do
    test "fetches calls", %{test: my_name} do
      System.pid()
      File.cwd!()
      ExUnitTracer.current_test()

      {_, my_calls} = Enum.find(ExUnitTracer.calls(), fn {test, _} -> test.name == my_name end)

      assert {System, :pid, []} in my_calls
      assert {File, :cwd!, []} in my_calls
      assert {ExUnitTracer, :current_test, []} in my_calls
    end
  end

  describe "current_test" do
    test "returns the current test without a context" do
      %ExUnit.Test{} = myself = ExUnitTracer.current_test()

      assert myself.name == :"test current_test returns the current test without a context"
      assert myself.module == __MODULE__
      assert myself.case == __MODULE__
    end

    test "returns the current test with a context", context do
      %ExUnit.Test{} = myself = ExUnitTracer.current_test()

      assert myself.name == context.test
      assert myself.module == context.module
      assert myself.case == context.case

      # Must be dropped because `case` is in `myself` and not in `myself.tags`
      assert myself.tags == Map.drop(context, [:case])
    end
  end
end
