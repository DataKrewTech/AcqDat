defmodule Acqdat.Model.SensorNotification do
  @moduledoc """
  Models functions for configuring data for sensor notifications.
  """

  alias Acqdat.Schema.SensorNotifications, as: SNotifications
  alias Acqdat.Repo
  alias Acqdat.Notification.PolicyMap

  def create(params) do
    changeset = SNotifications.changeset(%SNotifications{}, params)
    Repo.insert(changeset)
  end

  def update(notification, params) do
    changeset = SNotifications.changeset(notification, params)
    Repo.update(changeset)
  end

  def get(id) do
    case Repo.get(SNotifications, id) do
      nil ->
        {:error, "not found"}

      notification ->
        notification = Repo.preload(notification, [sensor: [:device, :sensor_type]])
        {:ok, notification}
    end
  end

  def get_by_sensor(sensor_id) do
    Repo.get_by(SNotifications, sensor_id: sensor_id)
  end

  def get_all() do
    SNotifications |> Repo.all() |> Repo.preload(sensor: :device)
  end

  def delete(id) do
    SNotifications
    |> Repo.get(id)
    |> Repo.delete()
  end

  def get_policies() do
    policies = PolicyMap.policies()

    Enum.map(policies, fn policy ->
      module = String.to_existing_atom(policy)
      rule_name = module.rule_name
      {rule_name, policy}
    end)
  end

  def policy_preferences(module, params) do
    module = String.to_existing_atom(module)
    module.rule_preferences(params)
  end
end
