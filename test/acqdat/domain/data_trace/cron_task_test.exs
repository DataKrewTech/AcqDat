defmodule Acqdat.DataTrace.CronTaskTest do
  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.DataTrace.CronTask
  alias Acqdat.Model.Sensor

  # TODO: Implement the test with mock http.
  describe "send_data/0" do
    test "sends data" do
      sensor = insert(:sensor)

      Enum.map(1..4, fn i ->
        params = %{"temp" => 23 + i, "humid" => 10 + i}
        Sensor.insert_data(sensor, params)
      end)

      # result = CronTask.send_data()
    end
  end
end
