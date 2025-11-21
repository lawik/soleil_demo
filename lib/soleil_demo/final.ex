defmodule SoleilDemo.Final do
  use Task, restart: :transient

  require Logger

  alias SoleilDemo.BatteryLog

  @attempts 6
  @wait_time 10_000
  @sleep_mins 5

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    Logger.warning("Sleeping for #{@sleep_mins} minutes")

    with {:report, :ok} <- {:report, send_nerveshub_report(timeout: 15_000)},
         {:update, :ok} <- {:update, wait_for_update()} do
      Soleil.sleep_for(@sleep_mins, :minute)
      :ok
    else
      {:report, {:error, :timeout}} ->
        Logger.error("Not connected to NervesHub - unable to send report")
    end

    case Soleil.wakeup_reason() do
      :alarm ->
        Process.sleep(:timer.minutes(1))
        :ok

      :manual ->
        # When woken, stay up long
        Process.sleep(:timer.minutes(15))
        :ok
    end

    Soleil.sleep_for(@sleep_mins, :minute)
  end

  defp wait_for_update() do
    case {NervesHubLink.connected?(), NervesHubLink.status()} do
      {_, :updating} ->
        Logger.info("Waiting for update to complete")
        Process.sleep(:timer.minutes(1))
        wait_for_update()

      _ ->
        :ok
    end
  end

  defp send_nerveshub_report(opts) do
    timeout = Keyword.fetch!(opts, :timeout)
    delay = Keyword.get(opts, :delay, 50)
    number_of_tries = div(timeout, delay)

    case wait_for_nerveshub_extensions(number_of_tries, delay) do
      :ok ->
        NervesHubLink.Extensions.Health.send_report()

      error ->
        error
    end
  end

  defp wait_for_nerveshub_extensions(0, _delay), do: {:error, :timeout}

  defp wait_for_nerveshub_extensions(tries, delay) do
    if NervesHubLink.extensions_connected?() do
      :ok
    else
      Process.sleep(delay)
      wait_for_nerveshub_extensions(tries - 1, delay)
    end
  end

  def environment(value) do
    SoleilDemo.Environment.latest()
    |> Map.get(value)
  rescue
    _ ->
      nil
  end

  def battery() do
    case Soleil.battery_info() do
      {:ok, info} ->
        info

      _ ->
        %{
          state_of_charge: 0,
          voltage: 0,
          current: 0,
          temperature: 0
        }
    end
  end
end
