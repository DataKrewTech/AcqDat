defmodule AcqdatWeb.API.ToolManagementController do
  use AcqdatWeb, :controller

  alias Acqdat.Context.ToolManagement

  def verify_employee(conn, params) do
    %{"user_uuid" => uuid} = params
    {status, data} = ToolManagement.verify_employee(%{uuid: uuid})
    render(conn, "employee_verified.json", status: status, data: data)
  end
end
