defmodule AcqdatWeb.EnergyManagementView do
  use AcqdatWeb, :view

  def render("current_voltage_senor_data.json", %{sensor_data: data}) do
    %{
      "data" => data
    }
  end
end
