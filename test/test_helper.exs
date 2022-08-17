if ExUnitTracer.Monitor |> Process.whereis() |> is_nil() do
  ExUnitTracer.start!(mode: :all)
end

ExUnit.start()
