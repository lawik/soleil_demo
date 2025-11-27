defmodule SoleilDemo.HomeAssistant.BatteryVoltage do
  use Homex.Entity.Sensor,
    name: "battery-voltage",
    unit_of_measurement: "V",
    device_class: "voltage",
    update_interval: :never

  def handle_init(entity) do
    case Soleil.battery_info() do
      {:ok, info} ->
        entity |> set_value(info.voltage)

      _ ->
        entity
    end
  end
end
