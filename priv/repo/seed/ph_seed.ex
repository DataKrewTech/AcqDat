defmodule Seed.PhTurbidityData do
  alias Acqdat.Schema.{SensorType, Sensor, Device, SensorData}
  alias Acqdat.Repo
  import Ecto.Query

  @type_list [
    %{name: "pH", make: "Adafruit", visualizer: "", identifier: "pH",
      value_keys: ["pH"]},
    %{name: "Turbidity", make: "Adafruit", visualizer: "", identifier: "turbidity",
      value_keys: ["ntu"]}
  ]

  @device_manifest [
    %{uuid: "ffab4474a3a811e998ef8cdcd4201028", name: "DeviceWaterTank2", access_token: "abcd1234"},
    %{uuid: "2960ee5ea3a911e9bbaa8cdcd4201028", name: "DeviceWaterTank3", access_token: "abcd1234"}
  ]

  def seed_data() do
    {_, sensor_types} = seed_sensor_types()
    {_, [device_1, device_2]} = seed_devices()
    sensors = seed_sensors(sensor_types, device_1, device_2)
  end

  def remove_data() do
    query = from(
      device in Device,
      where: device.uuid in ["ffab4474a3a811e998ef8cdcd4201028", "2960ee5ea3a911e9bbaa8cdcd4201028"]
    )
    Repo.delete_all(query)

    query = from(
      sensor_type in SensorType,
      where: sensor_type.name in ["pH", "Turbidity"]
    )
    Repo.delete_all(query)
  end

  defp seed_devices() do
    entries = @device_manifest
    |> Enum.map(fn device ->
      device
      |> Map.put(:inserted_at, DateTime.truncate(DateTime.utc_now(), :second))
      |> Map.put(:updated_at, DateTime.truncate(DateTime.utc_now(), :second))
    end)

    Repo.insert_all(Device, entries, returning: true)
  end

  defp seed_sensor_types() do
    entries = @type_list
    |> Enum.map(fn sensor_type ->
      sensor_type
      |> Map.put(:inserted_at, DateTime.truncate(DateTime.utc_now(), :second))
      |> Map.put(:updated_at, DateTime.truncate(DateTime.utc_now(), :second))
    end)

    Repo.insert_all(SensorType, entries, returning: true)
  end

  defp seed_sensors(sensor_types, device_1, device_2) do
    sensor_manifest = for sensor_type <- sensor_types, device <- [device_1, device_2] do
      %{sensor_type_id: sensor_type.id, device_id: device.id, uuid: UUID.uuid1(:hex), name: sensor_type.name,
        inserted_at: DateTime.truncate(DateTime.utc_now(), :second),
        updated_at:  DateTime.truncate(DateTime.utc_now(), :second)
      }
    end
    Repo.insert_all(Sensor, sensor_manifest)
  end

  def seed_ph_data() do
    sensor_type = "pH"
    [sensor_1, sensor_2] = Repo.all(from(sensor in Sensor, where: sensor.name == ^sensor_type, select: sensor))
    start_time = DateTime.from_unix!(1553047620)
    end_time = DateTime.from_unix!(1553059680)
    result_1 = iterate(sensor_1.id, start_time, end_time, start_time, [], "pH")
    Repo.insert_all(SensorData, result_1)
    :random.seed(:os.timestamp())
    result_2 = iterate(sensor_2.id, start_time, end_time, start_time, [], "pH")
    Repo.insert_all(SensorData, result_2)
  end

  def seed_turbidity_data() do
    sensor_type = "Turbidity"
    [sensor_1, sensor_2] = Repo.all(from(sensor in Sensor, where: sensor.name == ^sensor_type, select: sensor))
    start_time = DateTime.from_unix!(1553047620)
    end_time = DateTime.from_unix!(1553059680)
    result_1 = iterate(sensor_1.id, start_time, end_time, start_time, [], "tur")
    Repo.insert_all(SensorData, result_1)
    :random.seed(:os.timestamp())
    result_2 = iterate(sensor_2.id, start_time, end_time, start_time, [], "tur")
    Repo.insert_all(SensorData, result_2)
  end

  def remove_ph_data() do
    sensor_type = "pH"
    [sensor_1, sensor_2] = Repo.all(from(sensor in Sensor, where: sensor.name == ^sensor_type, select: sensor))
    query = from(data in SensorData, where: data.sensor_id in ^[sensor_1.id, sensor_2.id])
    Repo.delete_all(query)
  end

  def remove_turbidity_data() do
    sensor_type = "Turbidity"
    [sensor_1, sensor_2] = Repo.all(from(sensor in Sensor, where: sensor.name == ^sensor_type, select: sensor))
    query = from(data in SensorData, where: data.sensor_id in ^[sensor_1.id, sensor_2.id])
    Repo.delete_all(query)
  end

  defp iterate(sensor_id, start_time, end_time, acc, datapoint, type) do
    if acc < end_time do
      value = get_value(type)
      acc = Timex.shift(acc, minutes: 1)
      data = [%{sensor_id: sensor_id, datapoint: value, inserted_timestamp: acc, inserted_at: acc, updated_at: acc} | datapoint]
      iterate(sensor_id, start_time, end_time, acc, data, type)
    else
      datapoint
    end
  end

  def get_value("pH") do
    value = (7 - :random.uniform()) |> Decimal.from_float() |> Decimal.round(2) |> Decimal.to_float()
    %{"pH" => value}
  end

  def get_value("tur") do
    value = 3000 - :random.uniform(6)
    %{"ntu" => value}
  end

end
