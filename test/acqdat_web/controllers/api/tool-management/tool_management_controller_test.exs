defmodule AcqdatWeb.API.ToolManagementControllerTest do
  use ExUnit.Case, async: true
  use AcqdatWeb.ConnCase
  import Acqdat.Support.Factory

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
    test "fails for bad params", context do
      %{conn: conn} = context

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

    @tag tool_count: 2
    test "issue a list of tools", context do
      %{tools: tools, employee: employee, tool_box: tool_box,
      conn: conn} = context
      params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => tool_uuid_list(tools),
        "transaction" => "issue"}

      result = conn |> post("/api/tl-mgmt/tool-transaction", params) |> json_response(200)
      assert %{"status" => "success", "data" => "transaction issue succeded"} == result
    end

    @tag tool_count: 2
    test "error if non tool ids not found", context do
      %{employee: employee, tool_box: tool_box,
      conn: conn} = context
      params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => ["1234", "abcd"],
        "transaction" => "issue"}

      result = conn |> post("/api/tl-mgmt/tool-transaction", params) |> json_response(200)
      assert %{"status" => "error", "errors" => "no issuable tools"} == result
    end

    @tag tool_count: 2
    test "successfully return a list of tools", context do
      %{tools: tools, employee: employee, tool_box: tool_box,
      conn: conn} = context
      issue_params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => tool_uuid_list(tools),
        "transaction" => "issue"}

      # issue a list of tools
      conn |> post("/api/tl-mgmt/tool-transaction", issue_params) |> json_response(200)

      # return a list of tools
      return_params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => tool_uuid_list(tools),
        "transaction" => "return"}
      result = conn |> post("/api/tl-mgmt/tool-transaction", return_params) |> json_response(200)
      assert result == %{"data" => "transaction return succeded", "status" => "success"}
    end

    @tag tool_count: 2
    test "error if no returnable tools found", context do
      %{tools: tools, employee: employee, tool_box: tool_box,
      conn: conn} = context
      issue_params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => tool_uuid_list(tools),
        "transaction" => "issue"}

      # issue a list of tools
      conn |> post("/api/tl-mgmt/tool-transaction", issue_params) |> json_response(200)

      # return a list of tools
      return_params = %{"user_uuid" => employee.uuid,
        "tool_box_uuid" => tool_box.uuid, "tool_ids" => ["abcd", "1234"],
        "transaction" => "return"}
      result = conn |> post("/api/tl-mgmt/tool-transaction", return_params) |> json_response(200)
      assert result == %{"status" => "error", "errors" => "no returnable tools"}
    end

  end

  defp tool_uuid_list(tools) do
    Enum.map(tools, fn tool ->
      tool.uuid
    end)
  end
end
