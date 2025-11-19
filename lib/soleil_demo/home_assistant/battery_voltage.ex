defmodule SoleilDemo.HomeAssistant.BatteryVoltage do
  use Homex.Entity.Sensor,
    name: "battery-voltage",
    unit_of_measurement: "V",
    device_class: "battery"

  def handle_timer(entity) do
    info = Soleil.battery_info()
    entity |> set_value(info.voltage)
  end
end
