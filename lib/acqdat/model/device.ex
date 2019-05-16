defmodule Acqdat.Model.Device do

  alias Acqdat.Schema.Device
  alias Acqdat.Repo
  alias Acqdat.Model.Sensor

  def create(params) do
    changeset = Device.changeset(%Device{}, params)
    Repo.insert(changeset)
  end

  def get(id) when is_integer(id) do
    case Repo.get(Device, id) do
      nil ->
        {:error, "not found"}
      device ->
        {:ok, device}
    end
  end

  def get(query) when is_map(query) do
    case Repo.get_by(Device, query) do
      nil ->
        {:error, "not found"}
      device ->
        {:ok, device}
    end
  end

  def update(device, params) do
    changeset = Device.update_changeset(device, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(Device)
  end

  def delete(id) do
    Device
    |> Repo.get(id)
    |> Repo.delete()
  end

  @doc """
  Adds data for the device provided in the params.

  Expects following keys:
  `device_id` => expect device uuid field to be sent under the key.
  `sensor_data` => expects a map which contains data for all the sensors
                   configured for the device.
  `timestamp` => utc timestamp from the device when data was collected.
  """
  @spec add_data(map) :: {:ok, Acqdat.Schema.SensorData.t()}
                        | {:error, String.t()}
                        | {:error, Ecto.Changeset.t()}
  def add_data(params) do
    %{"device_id" => uuid, "sensor_data" => data,
      "timestamp" => _timestamp} = params
    case get(%{uuid: uuid}) do
      {:ok, device} ->
        insert_data(device, data)
      {:error, message} ->
        {:error, message}
    end
  end

  defp insert_data(device, data) do
    result_array = Enum.map(data, fn {sensor, sensor_data} ->
      result = Sensor.get(%{device_id: device.id, name: sensor})
      insert_sensor_data(result, sensor_data)
    end)

    if Enum.any?(result_array, fn {status, _data} -> status == :error end) do
      {:error, "insert error"}
    else
      {:ok, "data inserted successfully"}
    end
  end

  defp insert_sensor_data({:error, _data}, _), do: {:error, "sensor not found"}
  defp insert_sensor_data({:ok, sensor}, sensor_data) do
    Sensor.insert_data(sensor, sensor_data)
  end

end
