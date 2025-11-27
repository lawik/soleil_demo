defmodule SoleilDemo.HomeAssistant.EnvironmentTemperature do
  use Homex.Entity.Sensor,
    name: "environment-temperature",
    unit_of_measurement: "°C",
    device_class: "temperature",
    update_interval: :never

  def handle_init(entity) do
    %{temperature: value} = SoleilDemo.Environment.latest()
    entity |> set_value(value)
  end
end
