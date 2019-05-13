defmodule AcqdatWeb.SensorController do
  use AcqdatWeb, :controller

  alias Acqdat.Schema.Sensor, as: SensorSchema
  alias Acqdat.Model.Sensor
  alias Acqdat.Repo

  def new(conn, %{"device_id" => id}) do
    device_id = String.to_integer(id)

    changeset = SensorSchema.changeset(%SensorSchema{}, %{device_id: device_id})
    render(conn, "new.html", changeset: changeset, device_id: device_id)
  end

  def create(conn, %{"sensor" => params, "device_id" => device_id}) do
    params = Map.put(params, "device_id", device_id)
    device_id = String.to_integer(device_id)

    case Sensor.create(params) do
      {:ok, _sensor} ->
        conn
        |> redirect(to: Routes.device_path(conn, :show, device_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, device_id: device_id)
    end
  end

  def edit(conn, %{"device_id" => device_id, "id" => id}) do
    device_id = String.to_integer(device_id)

    id
    |> String.to_integer()
    |> Sensor.get()
    |> case do
      {:ok, sensor} ->
        changeset = SensorSchema.changeset(sensor, %{})
        render(conn, "edit.html", changeset: changeset, sensor: sensor, device_id: device_id)
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.device_path(conn, :show, device_id))
    end
  end

  def show(conn, %{"device_id" => device_id, "id" => id}) do
    id
    |> String.to_integer()
    |> Sensor.get()
    |> case do
      {:ok, sensor} ->
        sensor = Repo.preload(sensor, [:sensor_type, :device])
        render(conn, "show.html", sensor: sensor, device_id: device_id)
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.device_path(conn, :show, device_id))
    end
  end

  def update(conn, %{"device_id" => device_id, "id" => id, "sensor" => params}) do
    id = String.to_integer(id)
    device_id = String.to_integer(device_id)
    {:ok, sensor} = Sensor.get(id)

    case Sensor.update(sensor, params) do
      {:ok, _sensor} ->
        conn
        |> put_flash(:info, "Record updated!")
        |> redirect(to: Routes.device_path(conn, :show, device_id))
      {:error, changeset} ->
        conn
        |> put_flash("error", "There are some errors!")
        |> render("edit.html", changeset: changeset, sensor: sensor, device_id: device_id)
    end
  end

  def delete(conn, %{"device_id" => device_id, "id" => id}) do
    id
    |> String.to_integer()
    |> Sensor.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.device_path(conn, :show, String.to_integer(device_id)))
      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.device_path(conn, :show, String.to_integer(device_id)))
    end
  end

end
