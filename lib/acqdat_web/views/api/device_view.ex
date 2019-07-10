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
end
