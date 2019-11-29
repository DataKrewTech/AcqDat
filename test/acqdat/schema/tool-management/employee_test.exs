defmodule Acqdat.Schema.ToolManagement.EmployeeTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.Schema.ToolManagement.Employee

  describe "create_changeset/2" do
    test "returns valid changeset" do
      params = %{name: "IronMan", phone_number: "1234567", role: "worker"}
      %{valid?: validity} = Employee.create_changeset(%Employee{}, params)
      assert validity
    end

    test "returns invalid changeset if params empty" do
      params = %{}
      %{valid?: validity} = changeset = Employee.create_changeset(%Employee{}, params)
      refute validity
      assert %{
        name: ["can't be blank"],
        phone_number: ["can't be blank"],
        role: ["can't be blank"]
      } == errors_on(changeset)
    end
  end

  describe "update_changeset/2" do
    test "uuid does not change after update" do
      employee = insert(:employee)
      changeset = Employee.update_changeset(employee, %{name: "SuperMan"})
      assert employee.uuid == Ecto.Changeset.get_field(changeset, :uuid)
    end
  end
end
