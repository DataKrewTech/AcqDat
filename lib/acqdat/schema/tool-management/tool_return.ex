defmodule Acqdat.Schema.ToolManagement.ToolReturn do
   @moduledoc """
  Models metadata table to store tool issue information.
  """

  use Acqdat.Schema
  alias Acqdat.Schema.ToolManagement.{Employee, Tool, ToolBox, ToolIssue}

  @typedoc """
    `issue_time`: time at which tool was issued.
    `employee_id`: employee id of person who issued.
    `tool_id`: id of the tool issued.
    `tool_box_id`: id of box from which tool was issued.
  """
  @type t :: %__MODULE__{}

  schema("acqdat_tm_tool_return") do
    field(:return_time, :utc_datetime)

    #associations
    belongs_to(:employee, Employee)
    belongs_to(:tool, Tool)
    belongs_to(:tool_box, ToolBox)
    belongs_to(:tool_issue, ToolIssue)

    timestamps()
  end

  @permitted ~w(issue_time employee_id tool_id tool_box_id)a

  def changeset(%__MODULE__{} = tool_issue, params) do
    tool_issue
    |> cast(params, @permitted)
    |> validate_required(@permitted)
    |> assoc_constraint(:employee)
    |> assoc_constraint(:tool)
    |> assoc_constraint(:tool_box)
  end
end
