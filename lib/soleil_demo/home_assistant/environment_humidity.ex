defmodule SoleilDemo.HomeAssistant.EnvironmentHumidity do
  use Homex.Entity.Sensor,
    name: "environment-humidity",
    unit_of_measurement: "%",
    device_class: "humidity",
    update_interval: :never

  def handle_init(entity) do
    %{humidity: value} = SoleilDemo.Environment.latest()
    entity |> set_value(Float.round(value, 2))
  end
end
