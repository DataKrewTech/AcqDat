defmodule Acqdat.Model.SensorNotification do
  @moduledoc """
  Models functions for configuring data for sensor notifications.
  """

  alias Acqdat.Schema.SensorNotifications, as: SNotifications
  alias Acqdat.Repo

  def create(params) do
    changeset = SNotifications.changeset(%SNotifications{}, params)
    Repo.insert(changeset)
  end

  def update(device, params) do
    changeset = SNotifications.changeset(device, params)
    Repo.update(changeset)
  end

  def get(id) do
    case Repo.get(SNotifications, id) do
      nil ->
        {:error, "not found"}
      notification ->
        {:ok, notification}
    end
  end

  def get_all() do
    SNotifications |> Repo.all() |> Repo.preload([sensor: :device])
  end

end
