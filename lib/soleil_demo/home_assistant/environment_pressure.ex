defmodule SoleilDemo.HomeAssistant.EnvironmentPressure do
  use Homex.Entity.Sensor,
    name: "environment-pressure",
    unit_of_measurement: "%",
    device_class: "pressure",
    retain: true

  def handle_timer(entity) do
    %{pressure: value} = SoleilDemo.Environment.latest()
    entity |> set_value(value)
  end
end
