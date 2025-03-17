defmodule SoleilDemo.BatteryLogger do
  use Task, restart: :transient

  require Logger

  alias SoleilDemo.BatteryLog

  @sleep_mins Application.compile_env!(:soleil_demo, [__MODULE__, :sleep_time_mins])

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    with :alarm <- Soleil.wakeup_reason(),
         {:ok, battery_info} <- Soleil.battery_info(),
         {:ok, _battery_log} <- BatteryLog.new(battery_info) do
      Logger.warning("Logged battery data. Sleeping for #{@sleep_mins} minutes")

      case send_nerveshub_report(timeout: 15_000) do
        :ok ->
          Logger.info(
            "Sent health report to NervesHub? #{NervesHubLink.Extensions.Health.report_sent?()}"
          )

        {:error, :timeout} ->
          Logger.error("Not connected to NervesHub - unable to send report")
      end

      Soleil.sleep_for(@sleep_mins, :minute)
      :normal
    else
      :manual ->
        Logger.warning(
          "Wakeup reason was :manual, sleeping after 5 minutes (pid: #{inspect(self())})"
        )

        Process.sleep(:timer.minutes(5))
        Soleil.sleep_for(@sleep_mins, :minute)
        :normal

      {:error, _changeset} ->
        Logger.error("Failed to create new battery log")
        :error
    end
  end

  defp send_nerveshub_report(opts) do
    timeout = Keyword.fetch!(opts, :timeout)
    delay = Keyword.get(opts, :delay, 50)
    number_of_tries = div(timeout, delay)

    case wait_for_nerveshub_extensions(number_of_tries, delay) do
      :ok -> NervesHubLink.Extensions.Health.send_report()
      error -> error
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
end
