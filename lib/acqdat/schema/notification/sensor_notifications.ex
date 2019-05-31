defmodule Acqdat.Schema.SensorNotifications do
  @moduledoc """
  Models configurations for sensor notifications.

  Each sensor can have notifications associated with it. Since a sensor can have
  multiple value keys. Each value key can different notifications set.
  """

  use Acqdat.Schema
  alias Acqdat.Schema.Sensor
  alias Acqdat.Notification.PolicyMap

  @typedoc """
  `rule_values`: Holds rule for each `value key` of the sensor. Each value key of the sensor
          will have a module which depicts the logic to be used for checking for
          notification.
          ## Example
          sensor_1,
          %{
            "temp" => %{
              "module" => Module Name,
              "preferences" => {
                "pref1" => value1
                "pref2" => value2
              }
            }
          }
  `sensor_id`: id of the sensor for which notifications would be set.
  """
  @type t :: %__MODULE__{}

  @callback rule_name() :: name :: String.t()
  @callback eligible?(sensor :: Sensor, value_key :: String.t(), value :: Decimal) :: true | false

  schema("acqdat_sensor_notifications") do
    field(:rule_values, :map)
    field(:alarm_status, :boolean, default: false)
    belongs_to(:sensor, Sensor, on_replace: :delete)

    timestamps()
  end

  @required_params ~w(sensor_id rule_values)a
  @optional_params ~w(alarm_status)a

  @permitted_params @required_params ++ @optional_params

  @spec changeset(
          __MODULE__.t(),
          map
        ) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = rule, params) do
    rule
    |> cast(params, @permitted_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:sensor)
    |> unique_constraint(:sensor_id)
    |> validate_embedded_data()
  end

  def validate_embedded_data(%Ecto.Changeset{valid?: true} = changeset) do
    {:ok, rule_values} = fetch_change(changeset, :rule_values)

    result_list = Enum.map(rule_values, fn {key, value} ->
      module = value["module"] |> String.to_atom()

      changeset = module.changeset(struct(module), value["preferences"])
      case add_preferences_change(key, changeset, value["module"]) do
        {:ok, _data} = result ->
          result
        {:error, _info} = result ->
          result
      end
    end)

    test_data = result_list
    |> Enum.reduce_while(%{}, fn
      {:ok, {key, value}}, acc ->
        {:cont, Map.put(acc, key, value)}
      {:error, {key, value}}, _acc ->
        value = map_error(key, value)
        changeset = add_error(changeset, :rule_values, value)
        {:halt, changeset}
    end)
    |> case do
      %Ecto.Changeset{} = changeset ->
        changeset
      %{} = data ->
        put_change(changeset, :rule_values, data)
    end

    require IEx
    IEx.pry
  end

  def validate_embedded_data(changeset, _module_key, _key), do: changeset

  defp add_preferences_change(key, %Ecto.Changeset{valid?: true} = embed_changeset, module) do
    data = embed_changeset.changes
    {:ok, module} = PolicyMap.dump(module)
    {:ok, {"#{key}",  %{"preferences" => data, "module" => module}}}
  end

  defp add_preferences_change(key, pref_changeset, _module) do
    additional_info =
      pref_changeset
      |> traverse_errors(fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    {:error, {"#{key}", additional_info}}
  end

  defp map_error(key, value) do
    Enum.reduce(value, acc, fun)
  end

end
