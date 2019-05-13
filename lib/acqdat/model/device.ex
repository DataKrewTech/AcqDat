defmodule Acqdat.Model.Device do

  alias Acqdat.Schema.Device
  alias Acqdat.Repo
  def create(params) do
    changeset = Device.changeset(%Device{}, params)
    Repo.insert(changeset)
  end

  def get(id) do
    case Repo.get(Device, id) do
      nil ->
        {:error, "not found"}
      device ->
        {:ok, device}
    end
  end

  def update(device, params) do
    changeset = Device.changeset(device, params)
    Repo.update(changeset)
  end

  def get_all() do
    Repo.all(Device)
  end

  def delete(id) do
    Device
    |> Repo.get(id)
    |> Repo.delete()
  end
end
