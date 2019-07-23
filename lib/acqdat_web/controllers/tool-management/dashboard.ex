defmodule AcqdatWeb.ToolManagement.DashboardController do
  use AcqdatWeb, :controller

  plug(:put_layout, {AcqdatWeb.ToolManagementView, "tool_management_layout.html"})

  def show(conn, _params) do
    render(conn, "show.html")
  end

end
