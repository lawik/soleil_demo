defmodule SoleilDemo.BatteryLog do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "battery_logs" do
    field :voltage, :float
    field :current, :float
    field :temperature, :float
    field :state_of_charge, :integer
    field :recorded_at, :utc_datetime
  end

  def changeset(%__MODULE__{} = log, attrs \\ %{}) do
    rec_at =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    log
    |> cast(attrs, [:voltage, :current, :temperature, :state_of_charge])
    |> validate_required([:voltage, :current, :temperature, :state_of_charge])
    |> put_change(:recorded_at, rec_at)
  end

  @spec new(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def new(attrs) do
    changeset(%__MODULE__{}, attrs)
    |> SoleilDemo.Repo.insert()
  end
end
