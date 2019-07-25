defmodule Acqdat.Context.ToolManagement do
  @moduledoc """
  Module exposes APIs to work with tool-management.
  """
  alias Acqdat.Model.ToolManagement.{Employee, ToolBox, Tool}
  alias Acqdat.Repo
  alias Acqdat.Schema.ToolManagement.{ToolIssue, ToolReturn}

  def verify_employee(params) do
    case Employee.get(params) do
      {:ok, employee} ->
        {:ok, employee}
      {:error, message} ->
        {:error, message}
    end
  end

  @spec tool_transaction(map) :: {:ok, map} | {:error, map}
  def tool_transaction(params) do
    %{transaction: transaction_type} = params

    tool_manifest = Enum.reduce_while(params, %{}, fn
      {:tool_box_uuid, value}, acc ->
        get_tool_box_id(value, acc)
      {:tool_ids, value}, acc ->
        get_tool_ids(value, acc)
      {:user_uuid, value}, acc ->
        get_employee_id(value, acc)
      _, acc ->
        {:cont, acc}
    end)

    run_transaction(transaction_type, tool_manifest)
  end


  ##################################### Private Functions #####################

  defp run_transaction(_, %{error: _} = error_params) do
    {:error, error_params}
  end

  defp run_transaction("issue", tool_manifest) do
    issue_list = tool_issue_manifest(tool_manifest)
    Repo.insert_all(ToolIssue, issue_list)
    {:ok, "tools issued"}
  end

  defp run_transaction("return", tool_manifest) do
    return_list = tool_return_manifest(tool_manifest)
    require IEx
    IEx.pry
    {:ok, "tools returned"}
  end

  defp get_tool_box_id(uuid, accumulator) do
    case ToolBox.get(%{uuid: uuid}) do
      {:ok, tool_box} ->
        {:cont, Map.put(accumulator, :tool_box_id, tool_box.id)}
      {:error, message} ->
        {:halt, %{error: "tool_box_error", tool_box_id: message}}
    end
  end

  defp get_employee_id(uuid, accumulator) do
    case Employee.get(%{uuid: uuid}) do
      {:ok, tool_box} ->
        {:cont, Map.put(accumulator, :employee_id, tool_box.id)}
      {:error, message} ->
        {:halt, %{error: "employee error", employee_id: message}}
    end
  end

  defp get_tool_ids(tool_uuids, acc) do
    case Tool.get_all_by_uuids(tool_uuids) do
      [] ->
        {:halt, %{error: "tool error", tool_id: "not found"}}
      tool_ids ->
        {:cont, Map.put(acc, :tool_ids, tool_ids)}
    end
  end


  defp tool_issue_manifest(tool_manifest) do
    %{tool_box_id: tool_box_id, employee_id: employee_id,
      tool_ids: tool_ids} = tool_manifest
    time = DateTime.truncate(DateTime.utc_now(), :second)

    Enum.map(tool_ids, fn tool_id ->
      %{
        tool_id: tool_id,
        tool_box_id: tool_box_id,
        employee_id: employee_id,
        issue_time: time,
        inserted_at: time,
        updated_at: time,
      }
    end)
  end

  defp tool_return_manifest(tool_manifest) do
    %{ tool_ids: tool_ids} = tool_manifest
    Enum.reduce_while(tool_ids, [], fn tool_id, acc ->
      conditional_add_return(tool_id, acc, tool_manifest)
    end)
  end

  defp conditional_add_return(tool_id, acc, tool_manifest) do
    create_return_dump_manifest(get_tool_issue_id(tool_id), acc, tool_manifest, tool_id)
  end

  defp create_return_dump_manifest(nil,_,_,_) do
    {:halt, []}
  end
  defp create_return_dump_manifest(tool_issue_id, acc, tool_manifest, tool_id) do
    %{tool_box_id: tool_box_id, employee_id: employee_id} = tool_manifest
    time = DateTime.truncate(DateTime.utc_now(), :second)
    {:cont, [ %{
      tool_id: tool_id,
      tool_box_id: tool_box_id,
      employee_id: employee_id,
      tool_issue_id: tool_issue_id,
      return_time: time,
      inserted_at: time,
      updated_at: time,
    } | acc]}
  end


  defp get_tool_issue_id(tool_id) do

  end

end
