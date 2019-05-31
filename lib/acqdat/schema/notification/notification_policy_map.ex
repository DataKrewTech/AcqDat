defmodule Acqdat.Notification.PolicyMap do

  @module_policy_map %{
    "Elixir.Acqdat.Schema.Notification.RangeBased" => 0
  }
  @error "module not found"

  def load(param) do
    @module_policy_map
    |> Enum.find(fn {_key, value} ->
      value == param
    end)
    |> case do
      nil ->
        {:error, @error}
      {module, _value} ->
        {:ok, String.to_existing_atom(module)}
     end
  end

  def dump(param) do
    case Map.get(@module_policy_map, param) do
      nil ->
        {:error, "module not found"}
      module ->
        {:ok, module}
    end
  end

  def policies() do
    Map.keys(@module_policy_map)
  end

end
