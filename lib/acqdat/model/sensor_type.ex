defmodule Acqdat.Model.SensorType do
  @moduledoc """
  Exposes APIs for handling sensor type entity.
  """

  alias Acqdat.Repo
  alias Acqdat.Schema.SensorType

  @doc """
  Creates a new sensor type.
  """
  @spec create(map) :: {:ok, SensorType.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    changeset = SensorType.changeset(%SensorType{}, params)
    Repo.insert(changeset)
  end

  def get_all() do
    Repo.all(SensorType)
  end

  def get(id) when is_integer(id) do
    case Repo.get(SensorType, id) do
      nil ->
        {:error, "not found"}
      sensor_type ->
        {:ok, sensor_type}
    end
  end

  def get(query) when is_map(query) do
    Repo.get_by(SensorType, query)
  end

  @spec update(SensorType.t(), map) :: {:ok, SensorType.t()} | {:error, Ecto.Changeset.t()}
  def update(sensor_type, params) do
    changeset = SensorType.changeset(sensor_type, params)

    Repo.update(changeset)
  end

  def delete(id) do
    SensorType
    |> Repo.get(id)
    |> Repo.delete()
  end
end
