defmodule Acqdat.Schema.ToolManagement.ToolType do
  @moduledoc """
  Models a too type.
  """

  use Acqdat.Schema

  @type t :: %__MODULE__{}

  schema("acqdat_tm_tool_types") do
    field(:identifier, :string)

    timestamps()
  end

  @permitted ~w(identifier)a

  def changeset(%__MODULE__{} = tool_type, params) do
    tool_type
    |> cast(params, @permitted)
    |> validate_required(@permitted)
    |> unique_constraint(:identifier, message: "Tool type already exists!")
  end
end
