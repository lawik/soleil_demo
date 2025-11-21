defmodule SoleilDemo.HomeAssistant.EnvironmentTemperature do
  use Homex.Entity.Sensor,
    name: "environment-temperature",
    unit_of_measurement: "°C",
    device_class: "temperature",
    retain: true

  def handle_timer(entity) do
    %{temperature: value} = SoleilDemo.Environment.latest()
    entity |> set_value(value)
  end
end
