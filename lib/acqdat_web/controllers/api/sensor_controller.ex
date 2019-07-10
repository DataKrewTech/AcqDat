defmodule AcqdatWeb.API.SensorController do

  use AcqdatWeb, :controller
  alias Acqdat.Model.{Sensor, SensorData}

  def data(conn, %{"id" => id} = params) do
    start_time = Map.get(params, "start_time") || Timex.shift(DateTime.utc_now(), days: -100)
    end_time = Map.get(params, "end_time") || DateTime.utc_now()

    with {:ok, sensor} <- id |> String.to_integer() |> Sensor.get() do
      sensor_data = SensorData.time_data_by_sensor(start_time, end_time, sensor.id)
      sensor = sensor |> Map.from_struct() |> Map.put(:sensor_data, sensor_data)
      render(conn, "show.json-api", data: sensor, opts: [include: "sensor_data"])
    end
  end

end
