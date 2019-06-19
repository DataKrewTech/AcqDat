defmodule Acqdat.Domain.Notification do
  @moduledoc """
  Exposes APIs to handle notification
  """

  alias Acqdat.Model.Sensor
  alias Acqdat.Model.SensorNotification, as: SNotify

  def handle_notification(params) do
    %{device: device, data: data} = params

    Enum.each(data, fn {sensor, sensor_data} ->
      result = Sensor.get(%{device_id: device.id, name: sensor})
      process_sensor_data(result, sensor_data)
    end)
  end

  defp process_sensor_data({:error, _data}, _sensor_data), do: {:error, "sensor not found"}
  defp process_sensor_data({:ok, sensor}, sensor_data) do
    sensor.id
    |> SNotify.get_by_sensor()
    |> get_sensor_notification_rules(sensor_data)
  end

  def get_sensor_notification_rules(nil, _), do: {:error, "no rules set"}
  def get_sensor_notification_rules(notification_config, data) do

  end

  defp check_eligibilty(params) do

  end

  defp send() do

  end

end
