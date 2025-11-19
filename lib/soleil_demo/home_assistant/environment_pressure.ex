defmodule SoleilDemo.HomeAssistant.EnvironmentPressure do
  use Homex.Entity.Sensor,
    name: "environment-pressure",
    unit_of_measurement: "%",
    device_class: "air_pressure",
    retain: true

  def handle_timer(entity) do
    temp = SoleilDemo.BatteryLogger.environment(:pressure)
    entity |> set_value(temp)
  end
end
