defmodule SoleilDemo do
  @moduledoc """
  Documentation for `SoleilDemo`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SoleilDemo.hello()
      :world

  """
  def battery_percentage_metric do
    {:ok, battery_info} = Soleil.battery_info()
    battery_info.state_of_charge
  end
end
