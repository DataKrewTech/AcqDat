defmodule Acqdat.Model.ToolManagament.EmployeeTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.Model.ToolManagement.Employee

  describe "create/1" do
    test "creates an employee with supplied params" do
      params = %{name: "IronMan", phone_number: "1234567", role: "worker",
        card_uuid: permalink(4)}
      assert {:ok, _employee} = Employee.create(params)
    end

    test "fails if existing name and phone number combination used" do
      employee = insert(:employee)
      params = %{name: employee.name, phone_number: employee.phone_number,
        role: "worker", card_uuid: permalink(4) }
      assert {:error, changeset} = Employee.create(params)
      assert %{name: ["User already exists!"]} == errors_on(changeset)
    end
  end

  describe "get_all/0" do
    setup :employee_list

    @tag employee_count: 2
    test "returns a list of employee" do
      result = Employee.get_all()
      assert length(result) == 2
    end

    @tag employee_count: 0
    test "returns [] if no employees" do
      result = Employee.get_all()
      assert result == []
    end
  end

  describe "get/1" do
    test "returns an employee by id" do
      employee = insert(:employee)
      assert {:ok, _employee} = Employee.get(employee.id)
    end

    test "returns error tuple if employee not found" do
      assert {:error, message} = Employee.get(-1)
      assert message == "not found"
    end
  end

  describe "update/2" do
    setup do
      employee = insert(:employee)
      [employee: employee]
    end
    test "udpates successfully", context do
      %{employee: employee} = context
      params = %{name: "Superman"}
      assert {:ok, updated_employee} = Employee.update(employee, params)
      assert employee.id == updated_employee.id
      assert employee.name != updated_employee.name
    end
  end

  describe "employee_tool_issue_status/1" do
    setup do
      employee = insert(:employee)
      tool_box = insert(:tool_box)
      tool_issue_1 = insert(:tool_issue, employee: employee, tool_box: tool_box)
      tool_issue_2 = insert(:tool_issue, employee: employee, tool_box: tool_box)
      tool_issue_list = [tool_issue_1, tool_issue_2]

      [employee: employee, tool_issue_list: tool_issue_list]
    end

    test "returns list of tools issued but not returned", context do
      %{tool_issue_list: tool_issue_list, employee: employee} = context
      [tool_issue_1, tool_issue_2] = tool_issue_list

      # return tool 1
      tool_return(tool_issue_1)

      # tool two still with employee
      [tool] = Employee.employee_tool_issue_status(employee.id)
      assert tool.id == tool_issue_2.tool_id
    end

    test "empty list if all tools returned", context do
      %{tool_issue_list: tool_issue_list, employee: employee} = context
      [tool_issue_1, tool_issue_2] = tool_issue_list

      # return tool 1 and tool 2
      tool_return(tool_issue_1)
      tool_return(tool_issue_2)

      # no tools remaining with employee
      current_status = Employee.employee_tool_issue_status(employee.id)
      assert current_status == []
    end
  end

end
