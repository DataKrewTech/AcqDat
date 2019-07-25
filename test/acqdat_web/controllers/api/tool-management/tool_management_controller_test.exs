defmodule AcqdatWeb.API.ToolManagementControllerTest do
  use ExUnit.Case, async: true
  use AcqdatWeb.ConnCase
  import Acqdat.Support.Factory
  alias AcqdatWeb.API.ToolManagementController

  setup %{conn: conn} do
    conn = put_req_header(conn, "content-type", "application/json")
    [conn: conn]
  end

  describe "tool_transaction/2" do
    setup do
      employee = insert(:employee)
      tool_box = insert(:tool_box)
      [employee: employee, tool_box: tool_box]
    end

    setup :tool_list

    @tag tool_count: 2
    test "issue a list of tools", context do
      %{tools: tools, employee: employee, tool_box: tool_box,
      conn: conn} = context
      params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => tool_uuid_list(tools),
        "transaction" => "issue"}

      result = conn |> post("/api/tl-mgmt/tool-transaction", params) |> json_response(200)
      assert %{"data" => "tools issued", "status" => "success"} == result
    end

    @tag tool_count: 2
    test "fails for bad params", context do
      %{tools: tools, employee: employee, tool_box: tool_box,
      conn: conn} = context

      result = conn |> post("/api/tl-mgmt/tool-transaction", %{}) |> json_response(200)
      assert %{
          "errors" => %{
            "tool_box_uuid" => ["can't be blank"],
            "tool_ids" => ["can't be blank"],
            "user_uuid" => ["can't be blank"]
          },
          "status" => "error"
        } == result
    end
  end

  defp tool_uuid_list(tools) do
    Enum.map(tools, fn tool ->
      tool.uuid
    end)
  end
end
