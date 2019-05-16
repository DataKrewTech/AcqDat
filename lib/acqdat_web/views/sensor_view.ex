defmodule AcqdatWeb.SensorView do
  use AcqdatWeb, :view
  import AcqdatWeb.View.DataHelpers

  def sensor_data(sensor) do
    data = %{
      id: sensor.id,
      name: sensor.name,
      identifier: sensor.sensor_type.identifier,
      value_keys: sensor.sensor_type.value_keys
    }

    Jason.encode!(data)
  end

  def render("sensor_data.json", %{sensor_data: data}) do
    %{
      "data" => data
    }
  end
end
