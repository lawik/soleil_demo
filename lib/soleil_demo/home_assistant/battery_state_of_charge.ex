defmodule SoleilDemo.HomeAssistant.BatteryStateOfCharge do
  use Homex.Entity.Sensor,
    name: "battery-state-of-charge",
    unit_of_measurement: "%",
    device_class: "battery",
    update_interval: :never

  def handle_init(entity) do
    case Soleil.battery_info() do
      {:ok, info} ->
        entity |> set_value(info.state_of_charge)

      _ ->
        entity
    end
  end
end
