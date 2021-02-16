defmodule AcqdatWeb.API.DeviceView do
  use AcqdatWeb, :view
  use JaSerializer.PhoenixView

  location("/api/devices")

  attributes [:uuid, :name, :description]

  has_many(
    :sensors,
    serializer: AcqdatWeb.API.SensorView,
    include: false
  )


  def render("latest-data.json-api", %{data: data}) do
    data = Enum.reduce(data, %{}, fn map, acc ->
      Map.merge(acc, map)
    end)

    %{

      sensor_data: data
    }
  end
end
