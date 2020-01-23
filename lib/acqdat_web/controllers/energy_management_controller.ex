defmodule AcqdatWeb.EnergyManagementController do
  use AcqdatWeb, :controller
  import Phoenix.View, only: [render_to_string: 3]

  alias Acqdat.Model.Sensor

  def index(conn, _) do
    power_sensor_id = 27
    energy_sensor_id = 28
    uptime_sensor_id = 31

    latest_active_power =
      power_sensor_id
      |> Sensor.sensor_data("active_power")
      |> List.last
      |> List.last

    is_active = if latest_active_power > 0 do
      true
    else
      false
    end

    uptime =
      uptime_sensor_id
      |> Sensor.sensor_data("uptime")
      |> Enum.reduce(0, fn [_, date_uptime], total_uptime -> date_uptime + total_uptime end)

    power =
      energy_sensor_id
      |> Sensor.sensor_data("active_energy")
      |> Enum.reduce(0, fn[_, date_power], total_power -> date_power + total_power end)


    render(conn, "index.html", data: %{current_status: is_active, total_uptime: uptime, total_power: power})
  end

  def current_voltage_senor_data(conn, _) do
    avg_current_list = get_avg_current_data()
    avg_voltage_list = get_avg_voltage_data()

    result = %{
      avg_current: avg_current_list,
      avg_voltage: avg_voltage_list
    }

    conn
    |> put_status(200)
    |> render("current_voltage_senor_data.json", sensor_data: result)
  end

  def energy_consumption_electricity_bill(conn, _) do
    energy_sensor_id = 28

    active_energy = Sensor.sensor_data(energy_sensor_id, "active_energy")

    active_energy_map =
      active_energy
      |> Map.new(fn [k, v] -> { k, v } end)


    energy_consumption_map =
      active_energy_map
      |> Enum.reduce(%{}, fn {timestamp, energy}, energy_acc ->
        date = timestamp |> DateTime.from_unix!(:millisecond) |> Timex.Timezone.convert("Asia/Jakarta") |> DateTime.to_date |> Date.to_string
        energy_acc = if Map.has_key?(energy_acc, date) do
          value = energy_acc[date] ++ [energy]
          Map.put(energy_acc, date, value)
        else
          Map.put(energy_acc, date, [energy])
        end
        energy_acc
      end)

    energy_consumption_map =
      energy_consumption_map
      |> Enum.map(fn {date, daily_energy_list} ->
        [date, List.first(daily_energy_list) - List.last(daily_energy_list)]
      end)

    electricity_bill =
      energy_consumption_map
      |> Enum.map(fn [date, energy] ->
        [date, energy * 10000]
      end)

    result = %{
      daily_energy_consumption: energy_consumption_map,
      daily_bill: electricity_bill
    }

    conn
    |> put_status(200)
    |> render("current_voltage_senor_data.json", sensor_data: result)

  end

  defp get_avg_current_data() do
    current_sensor_id = 25

    l1_current = Sensor.sensor_data(current_sensor_id, "l1_current")
    l2_current = Sensor.sensor_data(current_sensor_id, "l2_current")
    l3_current = Sensor.sensor_data(current_sensor_id, "l3_current")

    l1_current_map =
      l1_current
      |> Map.new(fn [k, v] -> { k, v } end)

    l2_current_map =
      l2_current
      |> Map.new(fn [k, v] -> { k, v } end)

    l3_current_map =
      l3_current
      |> Map.new(fn [k, v] -> { k, v } end)

    avg_current = Map.keys(l1_current_map)
    |> Enum.map(fn date ->
      avg_current = (l1_current_map[date] + l2_current_map[date] + l3_current_map[date]) / 3
      [date, avg_current]
    end)

    avg_current_map =
      avg_current
      |> Enum.reduce(%{}, fn [timestamp, current], avg_current_map_acc ->
        date = timestamp |> DateTime.from_unix!(:millisecond) |> Timex.Timezone.convert("Asia/Jakarta") |> DateTime.to_date |> Date.to_string
        avg_current_map_acc = if Map.has_key?(avg_current_map_acc, date) do
          value = avg_current_map_acc[date] + current
          Map.put(avg_current_map_acc, date, value)
        else
          Map.put(avg_current_map_acc, date, current)
        end
        avg_current_map_acc
      end)

    avg_current_map
    |> Enum.map(fn {key, val} ->
      [key, val]
    end)
  end

  defp get_avg_voltage_data() do
    voltage_sensor_id = 26

    l1l2_voltage = Sensor.sensor_data(voltage_sensor_id, "l1l2_voltage")
    l2l3_voltage = Sensor.sensor_data(voltage_sensor_id, "l2l3_voltage")
    l3l1_voltage = Sensor.sensor_data(voltage_sensor_id, "l3l1_voltage")

    l1l2_voltage_map =
      l1l2_voltage
      |> Map.new(fn [k, v] -> { k, v } end)

    l2l3_voltage_map =
      l2l3_voltage
      |> Map.new(fn [k, v] -> { k, v } end)

    l3l1_voltage_map =
      l3l1_voltage
      |> Map.new(fn [k, v] -> { k, v } end)

    avg_voltage = Map.keys(l1l2_voltage_map)
    |> Enum.map(fn date ->
      avg_voltage = (l1l2_voltage_map[date] + l2l3_voltage_map[date] + l3l1_voltage_map[date]) / 3
      [date, avg_voltage]
    end)

    avg_voltage_map =
      avg_voltage
      |> Enum.reduce(%{}, fn [timestamp, voltage], avg_voltage_map_acc ->
        date = timestamp |> DateTime.from_unix!(:millisecond) |> DateTime.to_date |> Date.to_string
        avg_voltage_map_acc = if Map.has_key?(avg_voltage_map_acc, date) do
          value = avg_voltage_map_acc[date] + voltage
          Map.put(avg_voltage_map_acc, date, value)
        else
          Map.put(avg_voltage_map_acc, date, voltage)
        end
        avg_voltage_map_acc
      end)


    avg_voltage_map
    |> Enum.map(fn {key, val} ->
      [key, val]
    end)
  end

end
