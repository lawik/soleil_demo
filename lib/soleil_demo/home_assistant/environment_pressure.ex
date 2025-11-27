defmodule SoleilDemo.HomeAssistant.EnvironmentPressure do
  use Homex.Entity.Sensor,
    name: "environment-pressure",
    unit_of_measurement: "%",
    device_class: "pressure",
    update_interval: :never

  def handle_init(entity) do
    %{pressure: value} = SoleilDemo.Environment.latest()
    entity |> set_value(value)
  end
end
