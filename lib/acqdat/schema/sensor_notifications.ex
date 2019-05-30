defmodule Acqdat.Schema.SensorNotifications do
  @moduledoc """
  Models configurations for sensor notifications.

  Each sensor can have notifications associated with it. Since a sensor can have
  multiple value keys. Each value key can have upper or lower limit. If both are
  set it means the user wants notifications in a range otherwise it is assumed
  one of the limits needs to be met to send notification.
  ## Example
    sensor_1,
    [
      "temp" => %{
        "lower" => 20
        "upper" => 50
      }
    ]
  """

  use Acqdat.Schema
  alias Acqdat.Schema.Sensor

  schema("acqdat_sensor_notifications") do
    field(:rule_values, {:array, :map})
    belongs_to(:sensor, Sensor, on_replace: :delete)

    timestamps()
  end

  @required_params ~w(sensor_id rule_values)a

  def changeset(%__MODULE__{} = rule, params) do
    rule
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:sensor)
    |> unique_constraint(:sensor_id)
  end

end
