defmodule Acqdat.Model.ToolManagement.ToolType  do
  @moduledoc """
  Exposes APIs to interact with tool_type DB table.
  """

  alias Acqdat.Repo
  alias Acqdat.Schema.ToolManagement.ToolType

  def create(params) do
    changeset = ToolType.changeset(%ToolType{}, params)
    Repo.insert(changeset)
  end

  def get(id) when is_integer(id) do
    case Repo.get(ToolType, id) do
      nil ->
        {:error, "not found"}

      tool_type ->
        {:ok, tool_type}
    end
  end

  def get(query) when is_map(query) do
    case Repo.get_by(ToolType, query) do
      nil ->
        {:error, "not found"}

      tool_type ->
        {:ok, tool_type}
    end
  end

  def update(tool_type, params) do
    changeset = ToolType.changeset(tool_type, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(ToolType)
  end

  def delete(id) do
    ToolType
    |> Repo.get(id)
    |> Repo.delete()
  end
end
