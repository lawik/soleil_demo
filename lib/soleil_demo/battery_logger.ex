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
end
