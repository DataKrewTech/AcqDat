defmodule Acqdat.Model.SensorData do
  @moduledoc """
  The Module exposes helper functions to interact with sensor
  data.
  """
  import Ecto.Query
  alias Acqdat.Schema.SensorData

  @doc """
  Returns `query` for getting sensor data by `start_time` and `end_time`.
  """
  def get_by_time_range(start_time, end_time) do
    from(
      data in SensorData,
      where: data.inserted_at >= ^start_time and data.inserted_at <= ^end_time,
      preload: [sensor: :device]
    )
  end
end
