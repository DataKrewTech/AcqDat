defmodule Acqdat.Schema.SensorTypeTest do

  use ExUnit.Case, async: true
  use Acqdat.DataCase

  import Acqdat.Support.Factory
  alias Acqdat.Schema.SensorType

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{name: "temperature", make: "Adafruit",
        visualizer: "pie chart", identifier: "temperature"}

      assert %{valid?: validity} = SensorType.changeset(%SensorType{}, params)
      assert validity
    end

    test "returns invalid if params missing" do
      %{valid?: validity} = changeset = SensorType.changeset(%SensorType{}, %{})

      refute validity
      assert %{
        identifier: ["can't be blank"],
        name: ["can't be blank"]
      } == errors_on(changeset)
    end
  end
end
