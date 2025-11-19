defmodule SoleilDemo.HomeAssistant.EnvironmentGas do
  use Homex.Entity.Sensor,
    name: "environment-gas",
    unit_of_measurement: "",
    device_class: "environment"

  def handle_timer(entity) do
    temp = SoleilDemo.BatteryLogger.environment(:gas_resistance)
    entity |> set_value(temp)
  end
end
