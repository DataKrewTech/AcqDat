defmodule Acqdat.Schema.Notification.RangeBased do
  @moduledoc """
  Models range based notifications.
  """

  alias Acqdat.Schema.SensorNotifications
  @behaviour SensorNotifications

  use Acqdat.Schema
  @type t :: %__MODULE__{}
  @rule "RangeBasedPolicy"

  embedded_schema do
    field(:lower_limit, :decimal, default: 0.0)
    field(:upper_limit, :decimal, default: 0.0)
  end

  def changeset(%__MODULE__{} = rule, params) do
    rule
    |> cast(params, [:lower_limit, :upper_limit])
    |> validate_data()
  end

  @impl SensorNotifications
  def rule_name() do
    @rule
  end

  @impl SensorNotifications
  def rule_preferences(params) do
    %{
      name: @rule,
      rule_data: [
        %{
          key: :lower_limit,
          type: :input,
          value: params["lower_limit"]
        },
        %{
          key: :upper_limit,
          type: :input,
          value: params["upper_limit"]
        }
      ]
    }
  end

  @impl SensorNotifications
  def eligible?(sensor, value_key, value) do
    true
  end

  defp validate_data(%Ecto.Changeset{valid?: true} = changeset) do
    {:ok, lower_limit} = fetch_change(changeset, :lower_limit)
    {:ok, upper_limit} = fetch_change(changeset, :upper_limit)

    case Decimal.cmp(lower_limit, upper_limit) do
      :lt ->
        changeset
      :eq ->
        changeset

      _ ->
        Ecto.Changeset.add_error(changeset, :lower_limit, "lower limit should be less than upper")
    end
  end

  defp validate_data(changeset), do: changeset
end
