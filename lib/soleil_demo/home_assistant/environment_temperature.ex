defmodule SoleilDemo.HomeAssistant.EnvironmentTemperature do
  use Homex.Entity.Sensor,
    name: "environment-temperature",
    unit_of_measurement: "°C",
    device_class: "temperature",
    retain: true

  def handle_timer(entity) do
    temp = SoleilDemo.BatteryLogger.environment(:temperature)
    entity |> set_value(temp)
  end
end
