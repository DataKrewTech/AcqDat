defmodule Acqdat.Model.SensorTest do
  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory

  alias Acqdat.Model.Sensor

  describe "get_all_by_device" do
    setup do
      device = insert(:device)
      [device: device]
    end

    test "returns all sensors for a device", context do
      %{device: device} = context
      sensors = insert_list(3, :sensor, device: device)

      result = Sensor.get_all_by_device(device.id)
      assert length(sensors) == length(result)
    end
  end
end
