defmodule SoleilDemo.Metrics do
  @behaviour NervesHubLink.Extensions.Health.MetricSet

  require Logger

  @impl true
  def metrics() do
    {:ok, battery_info} = Soleil.battery_info()

    metrics =
      battery_info
      |> Enum.map(fn {k, v} -> {"Soleil_#{k}", v} end)
      |> Map.new()

    Logger.info("recording custom Soleil metrics: #{inspect(metrics)}")

    metrics
  end
end
