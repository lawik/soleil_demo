defmodule SoleilDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        SoleilDemo.Repo,
        {Ecto.Migrator,
         repos: Application.fetch_env!(:soleil_demo, :ecto_repos),
         skip: System.get_env("SKIP_MIGRATIONS") == "true"}
        # {Task,
        #  fn ->
        #    Process.sleep(:timer.minutes(5))
        #    Soleil.sleep_for(SoleilDemo.Soleil, 15, :minute)
        #  end}
        # Children for all targets
        # Starts a worker by calling: SoleilDemo.Worker.start_link(arg)
        # {SoleilDemo.Worker, arg},
      ] ++ children(Nerves.Runtime.mix_target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SoleilDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  defp children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: SoleilDemo.Worker.start_link(arg)
      # {SoleilDemo.Worker, arg},
    ]
  end

  defp children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: SoleilDemo.Worker.start_link(arg)
      # {SoleilDemo.Worker, arg},
      {Soleil, battery_capacity: 2000, battery_energy: 7400},
      SoleilDemo.BatteryLogger
    ]
  end
end
