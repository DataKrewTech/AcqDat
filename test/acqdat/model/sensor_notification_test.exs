defmodule Acqdat.Model.SensorNotificationTest do

  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.Model.SensorNotification, as: SNotify

  describe "get_by_sensor/1" do

    test "returns config when it exists for sensor" do
      config = insert(:sensor_notification)
    end
  end
end
