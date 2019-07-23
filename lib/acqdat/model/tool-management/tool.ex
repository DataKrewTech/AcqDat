defmodule Acqdat.Model.ToolManagement.Tool  do
  @moduledoc """
  Exposes APIs to interact with tool DB table.
  """

  alias Acqdat.Repo
  alias Acqdat.Schema.ToolManagement.Tool

  def create(params) do
    changeset = Tool.create_changeset(%Tool{}, params)
    Repo.insert(changeset)
  end

  def get(id) when is_integer(id) do
    case Repo.get(Tool, id) do
      nil ->
        {:error, "not found"}

      tool ->
        {:ok, tool}
    end
  end

  def get(query) when is_map(query) do
    case Repo.get_by(Tool, query) do
      nil ->
        {:error, "not found"}

      tool ->
        {:ok, tool}
    end
  end

  def update(tool, params) do
    changeset = Tool.update_changeset(tool, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(Tool)
  end

  def delete(id) do
    Tool
    |> Repo.get(id)
    |> Repo.delete()
  end
end
