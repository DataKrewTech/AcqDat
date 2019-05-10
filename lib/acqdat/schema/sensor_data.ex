defmodule Acqdat.Schema.SensorData do
  @moduledoc """
  Models the schema where all the data is finally stored
  for all the devices and sensors.

  Each row in this table corresponds to a sensor value at
  a particular time, for a particular device.
  """

  use Acqdat.Schema

  schema("acqdat_sensor_data") do
  end
end
