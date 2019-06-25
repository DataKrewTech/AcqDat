defmodule Acqdat.Model.SensorData do
  @moduledoc """
  The Module exposes helper functions to interact with sensor
  data.
  """
  import Ecto.Query
  alias Acqdat.Repo
  alias Acqdat.Schema.SensorData

  def get_by_time_range(start_time, end_time) do
    query =
      from(
        data in SensorData,
        where: data.inserted_at >= ^start_time and data.inserted_at <= ^end_time,
        preload: [sensor: :device]
      )

    Repo.all(query)
  end
end
