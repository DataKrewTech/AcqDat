defmodule Acqdat.Model.Sensor do

  alias Acqdat.Schema.{Sensor, SensorData}
  alias Acqdat.Repo
  def create(params) do
    changeset = Sensor.changeset(%Sensor{}, params)
    Repo.insert(changeset)
  end

  def get(id) when is_integer(id) do
    case Repo.get(Sensor, id) do
      nil ->
        {:error, "not found"}
      sensor ->
        {:ok, sensor}
    end
  end

  def get(query) when is_map(query) do
    case Repo.get_by(Sensor, query) do
      nil ->
        {:error, "not found"}
      sensor ->
        {:ok, sensor}
    end
  end

  def update(sensor, params) do
    changeset = Sensor.changeset(sensor, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(Sensor)
  end

  def delete(id) do
    Sensor
    |> Repo.get(id)
    |> Repo.delete()
  end

  def insert_data(sensor, sensor_data) do
    params = %{sensor_id: sensor.id,
      datapoint: sensor_data, inserted_timestamp: DateTime.utc_now()}
    changeset = SensorData.changeset(%SensorData{}, params)

    Repo.insert(changeset)
  end
end