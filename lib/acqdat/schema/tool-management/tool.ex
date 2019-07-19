defmodule Acqdat.Schema.ToolManagement.Tool do
  @moduledoc """
  Models a tool or asset that needs to be tracked.
  """

  use Acqdat.Schema
  alias Acqdat.Schema.ToolManagement.ToolBox

  @tool_prefix "T"

  @typedoc """
  `uuid`: a unique id assigned to the tool.
  `name`: name of the tool.
  `tool_type`: the category to which the tool belongs.
  """

  @type t :: %__MODULE__{}

  schema("acqdat_tm_tools") do
    field(:uuid, :string)
    field(:name, :string)
    field(:tool_type, :string)

    belongs_to(:tool_box, ToolBox)
    timestamps()
  end

  @permitted ~w(name tool_type uuid tool_box_id)a

  @spec create_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = tool, params) do
    tool
    |> cast(params, @permitted)
    |> add_uuid()
    |> common_changeset()
  end

  @spec update_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = tool, params) do
    tool
    |> cast(params, @permitted)
    |> common_changeset()
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_required(@permitted)
    |> assoc_constraint(:tool_box)
    |> unique_constraint(:name, message: "Unique tool name per tool box!")
  end

  defp add_uuid(%Ecto.Changeset{valid?: true} = changeset) do
    uuid = @tool_prefix <> permalink(4)
    changeset
    |> put_change(:uuid, uuid)
  end
  defp add_uuid(%Ecto.Changeset{valid?: false} = changeset), do: changeset
end
