defmodule ExUnitTracer.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_unit_tracer,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["test.calls": :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    []
  end
end
