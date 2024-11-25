defmodule SoleilDemo.Repo.Migrations.AddBatteryLog do
  use Ecto.Migration

  def change do

    create table(:battery_logs) do
      add :voltage, :float
      add :current, :float
      add :temperature, :float
      add :remaining_capacity, :integer
      add :state_of_charge, :integer

      add :recorded_at, :utc_datetime
    end

  end
end
