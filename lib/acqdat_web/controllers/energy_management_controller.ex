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
      |> List.last
      |> List.last

    power =
      energy_sensor_id
      |> Sensor.sensor_data("active_energy")
      |> List.last
      |> List.last

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

    energy_consumption_map =
      energy_sensor_id
      |> Sensor.sensor_data("active_energy")
      |> Enum.reduce(%{}, fn [timestamp, energy], energy_acc ->
        date = timestamp |> DateTime.from_unix!(:millisecond) |> Timex.Timezone.convert("Asia/Jakarta") |> DateTime.to_date |> Date.to_string
        energy_acc = if Map.has_key?(energy_acc, date) do
          value = energy_acc[date] ++ [energy]
          Map.put(energy_acc, date, value)
        else
          Map.put(energy_acc, date, [energy])
        end
        energy_acc
      end)
      |> Enum.map(fn {date, daily_energy_list} ->
        [date, List.last(daily_energy_list) - List.first(daily_energy_list)]
      end)

    electricity_bill =
      energy_consumption_map
      |> Enum.map(fn [date, energy] ->
        [date, energy * 1609]
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

    current_sensor_id
      |> Sensor.sensor_data
      |> Enum.map(fn [timestamp, %{"avg_current" => avg_current, "l1_current" => l1_current, "l2_current" => l2_current, "l3_current" => l3_current}] ->
        [timestamp, (l1_current + l2_current + l3_current)/3]
      end)
      |> Enum.reduce(%{}, fn [date, current], current_map ->
        current_map = if Map.has_key?(current_map, date) do
          value = current_map[date] ++ [current]
          Map.put(current_map, date, value)
        else
          Map.put(current_map, date, [current])
        end
      end)
      |> Enum.map(fn {date, current_list} ->
        total_current_list = length(current_list)
        avg_current = Enum.sum(current_list)/total_current_list
        [date, avg_current]
      end)
  end

  defp get_avg_voltage_data() do
    voltage_sensor_id = 26

    voltage_sensor_id
      |> Sensor.sensor_data
      |> Enum.map(fn [timestamp, %{"avg_ll_voltage" => avg_ll_voltage, "avg_ln_voltage" => avg_ln_voltage, "l1l2_voltage" => l1l2_voltage, "l2l3_voltage" => l2l3_voltage, "l3l1_voltage" => l3l1_voltage}] ->
        [timestamp, (l1l2_voltage + l2l3_voltage + l3l1_voltage)/3]
      end)
      |> Enum.reduce(%{}, fn [date, voltage], voltage_map ->
        voltage_map = if Map.has_key?(voltage_map, date) do
          value = voltage_map[date] ++ [voltage]
          Map.put(voltage_map, date, value)
        else
          Map.put(voltage_map, date, [voltage])
        end
      end)
      |> Enum.map(fn {date, voltage_list} ->
        total_voltage_list = length(voltage_list)
        avg_voltage = Enum.sum(voltage_list)/total_voltage_list
        [date, avg_voltage]
      end)
  end
end
