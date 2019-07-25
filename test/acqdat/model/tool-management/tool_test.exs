defmodule Acqdat.Model.ToolManagament.ToolTest do

  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.Model.ToolManagement.Tool

  describe "create/1" do

  end

  describe "update/2" do

  end

  describe "get/1" do

  end

  describe "get_all" do

  end

  describe "get_all_by_uuids/1" do
    setup  do
      tool_box = insert(:tool_box)

      [tool_box: tool_box]
    end

    setup :tool_list

    @tag tool_count: 3
    test "returns a list of tool ids", context do
      %{tools: tools} = context
      tool_uuids = Enum.map(tools, fn tool -> tool.uuid end)

      tool_ids = Tool.get_all_by_uuids(tool_uuids)
      assert length(tool_ids) == length(tool_uuids)
    end

    @tag tool_count: 3
    test "returns [] if no uuid match", context do
      %{tools: tools} = context
      tool_uuids = Enum.map(tools, fn tool -> tool.uuid end)

      tool_ids = Tool.get_all_by_uuids(["1234", "abcd"])
      assert tool_ids == []
    end
  end
end
