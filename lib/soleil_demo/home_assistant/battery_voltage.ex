defmodule SoleilDemo.HomeAssistant.BatteryVoltage do
  use Homex.Entity.Sensor,
    name: "battery-voltage",
    unit_of_measurement: "V",
    device_class: "voltage",
    retain: true

  def handle_timer(entity) do
    info = SoleilDemo.BatteryLogger.battery()
    entity |> set_value(info.voltage)
  end
end
