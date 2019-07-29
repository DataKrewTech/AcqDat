defmodule AcqdatWeb.View.DataHelpers do
  alias Acqdat.Model.{SensorType, ToolManagement.ToolType}

  @doc """
  Creates formatted data to be used in dropdown selection for association in forms.
  return => [{display name, value}, ...]
  passed to like => <%= select_input f, :country_id, formated_list(:country) %>
  Can also be used elsewhere.
  """
  def formatted_list(:sensor_type), do: SensorType.formatted_list()
  def formatted_list(:tool_type), do: ToolType.formatted_list()

end
