defmodule AcqdatWeb.ToolManagement.ToolView do

  use AcqdatWeb, :view
  import AcqdatWeb.View.DataHelpers
  alias Acqdat.Schema.ToolManagement.Tool

  def tool_status() do
    Tool.tool_status()
  end

end
