defmodule SoleilDemo.Environment do
  use GenServer
  require Logger

  @measurements 3

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_) do
    {:ok, pid} = Bme680.start_link()
    state = %{measurements: [], sensor: pid}
    {:ok, state, {:continue, :initial}}
  end

  def careful_measurement() do
    GenServer.call(__MODULE__, :careful_measurement, @measurements * 3000)
  end

  def quick_measurement() do
    GenServer.call(__MODULE__, :quick_measurement)
  end

  def latest() do
    GenServer.call(__MODULE__, :latest, @measurements * 3000)
  end

  defp add_measurement(state) do
    measurement = Bme680.measure(state.sensor)
    Logger.info("Environment sensor measurement: #{inspect(measurement)}")
    %{state | measurements: Enum.take([measurement | state.measurements], @measurements)}
  end

  def handle_continue(:initial, state) do
    {_, _, state} = handle_call(:careful_measurement, self(), state)
    {:noreply, state}
  end

  def handle_call(:quick_measurement, _from, state) do
    %{measurements: [m | _]} = state = add_measurement(state)

    {:reply, m, state}
  end

  def handle_call(:careful_measurement, _from, state) do
    # Grab n measurements with a 1-second delay between each measurement
    state =
      Enum.reduce(1..@measurements, state, fn _, acc ->
        :timer.sleep(1000)
        add_measurement(acc)
      end)

    avg =
      [:humidity, :temperature, :pressure]
      |> Enum.map(fn key ->
        {key, Enum.sum_by(state.measurements, &Map.get(&1, key)) / Enum.count(state.measurements)}
      end)
      |> Map.new()

    {:reply, avg, state}
  end

  def handle_call(:latest, _from, state) do
    avg =
      [:humidity, :temperature, :pressure]
      |> Enum.map(fn key ->
        {key, Enum.sum_by(state.measurements, &Map.get(&1, key)) / Enum.count(state.measurements)}
      end)
      |> Map.new()

    {:reply, avg, state}
  end
end
