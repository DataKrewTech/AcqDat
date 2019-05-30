defmodule Acqdat.Schema.SensorNotificationsTest do

  use ExUnit.Case, async: true
  use Acqdat.DataCase

  import Acqdat.Support.Factory
  alias Acqdat.Schema.SensorNotifications, as: SN
  alias Acqdat.Repo

  describe "changeset/2" do
    test "returns a valid changeset" do
      sensor = insert(:sensor)
      params = %{
        sensor_id: sensor.id,
        rule_values: [%{"temp" => %{"lower" => 20, "upper" => 50}}]
      }
      %{valid?: validity} = SN.changeset(%SN{}, params)
      assert validity
    end

    test "returns invalid changeset if sensor id not valid" do
      params = %{
        sensor_id: -1,
        rule_values: [%{"temp" => %{"lower" => 20, "upper" => 50}}]
      }
      changeset = SN.changeset(%SN{}, params)

      {:error, changeset} = Repo.insert(changeset)
      assert %{sensor: ["does not exist"]} == errors_on(changeset)
    end
  end
end
