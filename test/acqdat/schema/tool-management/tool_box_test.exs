defmodule Acqdat.Schema.ToolManagement.ToolBoxTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Acqdat.DataCase
  import Acqdat.Support.Factory
  alias Acqdat.Schema.ToolManagement.ToolBox

  describe "create_changeset/2" do
    test "returns a valid changeset" do
      params = %{name: "ToolBox1", description: "holds rubber tools"}
      %{valid?: validity} = changeset = ToolBox.create_changeset(%ToolBox{}, params)
      assert validity
    end

    test "returns invalid changeset if params empty" do
      params = %{}
      %{valid?: validity} = changeset = ToolBox.create_changeset(%ToolBox{}, params)
      refute validity
      assert %{name: ["can't be blank"]} == errors_on(changeset)
    end
  end

  describe "update_changeset/2" do

  end
end
