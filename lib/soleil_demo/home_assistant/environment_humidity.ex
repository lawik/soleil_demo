defmodule SoleilDemo.HomeAssistant.EnvironmentHumidity do
  use Homex.Entity.Sensor,
    name: "environment-humidity",
    unit_of_measurement: "%",
    device_class: "humidity",
    retain: true

  def handle_timer(entity) do
    %{humidity: value} = SoleilDemo.Environment.latest()
    entity |> set_value(value)
  end
end
