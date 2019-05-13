defmodule Acqdat.Model.Sensor do

  alias Acqdat.Schema.Sensor
  alias Acqdat.Repo
  def create(params) do
    changeset = Sensor.changeset(%Sensor{}, params)
    Repo.insert(changeset)
  end

  def get(id) do
    case Repo.get(Sensor, id) do
      nil ->
        {:error, "not found"}
      sensor ->
        {:ok, sensor}
    end
  end

  def update(sensor, params) do
    changeset = Sensor.changeset(sensor, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(Sensor)
  end

  def delete(id) do
    Sensor
    |> Repo.get(id)
    |> Repo.delete()
  end
end
