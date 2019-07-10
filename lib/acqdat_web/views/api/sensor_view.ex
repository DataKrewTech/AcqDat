defmodule AcqdatWeb.API.SensorView do
  use AcqdatWeb, :view
  use JaSerializer.PhoenixView

  attributes [:uuid, :name]

  def relationships(sensor, _conn) do
    %{
      sensor_data: %HasMany{
        serializer: AcqdatWeb.API.SensorDataView,
        include: false,
        data: sensor.sensor_data
      }
    }
  end

end

defmodule AcqdatWeb.API.SensorDataView do
  use AcqdatWeb, :view
  use JaSerializer.PhoenixView

  attributes [:values, :inserted_at]

  def values(sensor_data, _conn) do
    sensor_data.datapoint
  end

end
