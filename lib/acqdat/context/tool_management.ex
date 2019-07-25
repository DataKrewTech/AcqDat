defmodule Acqdat.Context.ToolManagement do
  @moduledoc """
  Module exposes APIs to work with tool-management.
  """
  alias Acqdat.Model.ToolManagement.Employee

  def verify_employee(params) do
    case Employee.get(params) do
      {:ok, employee} ->
        {:ok, employee}
      {:error, message} ->
        {:error, message}
    end
  end
end
