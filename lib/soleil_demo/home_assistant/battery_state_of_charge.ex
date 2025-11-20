defmodule SoleilDemo.HomeAssistant.BatteryStateOfCharge do
  use Homex.Entity.Sensor,
    name: "battery-state-of-charge",
    unit_of_measurement: "%",
    device_class: "battery",
    retain: true

  def handle_timer(entity) do
    info = SoleilDemo.BatteryLogger.battery()
    entity |> set_value(info.state_of_charge)
  end
end
