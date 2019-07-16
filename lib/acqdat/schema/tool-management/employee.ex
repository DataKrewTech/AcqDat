defmodule Acqdat.Schema.ToolManagement.Employee do
  @moduledoc """
  Models an Employee in tool-management.
  """

  use Acqdat.Schema

  @type t :: %__MODULE__{}

  schema("acqdat_tm_employees") do
    field(:name, :string)
    field(:uuid, :string)

    timestamps()
  end

  def create_changeset() do

  end

  def update_changeset() do

  end

end
