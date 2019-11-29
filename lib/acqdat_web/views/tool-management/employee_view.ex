defmodule AcqdatWeb.ToolManagement.EmployeeView do
  use AcqdatWeb, :view
  alias Acqdat.Schema.ToolManagement.Employee
  def employee_role() do
    Employee.employee_roles()
  end

end
