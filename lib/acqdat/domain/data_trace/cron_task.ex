defmodule Acqdat.DataTrace.CronTask do
  use Task
  alias Acqdat.Model.SensorData

  def start_link(_args) do
    Task.start_link(&cron/0)
  end

  def cron() do
    receive do
    after
      900_000 ->
        send_data()
        cron()
        # code
    end
  end

  def send_data() do
    start_time = Timex.shift(DateTime.utc_now(), minutes: -15)
    end_time = DateTime.utc_now()

    case SensorData.get_by_time_range(start_time, end_time) do
      [] ->
        :ok

      data ->
        data_trace(data)
    end
  end

  defp data_trace(data) do
    HTTPoison.post(url, body, headers \\ [], options \\ [])
  end
end
