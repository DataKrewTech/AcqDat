defmodule AcqdatWeb.DeviceController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.Device
  alias Acqdat.Schema.Device, as: DeviceSchema
  alias Acqdat.Repo

  def insert_data(conn, params) do
    AcqdatWeb.Endpoint.broadcast!("room:lobby", "data_point", params)

    case Device.add_data(params) do
      {:ok, _data} ->
        conn
        |> put_status(200)
        |> render("success.json", message: "success")

      {:error, _message} ->
        conn
        |> put_status(400)
        |> render("error.json", message: "error")
    end
  end

  def index(conn, _params) do
    devices = Device.get_all()
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    changeset = DeviceSchema.changeset(%DeviceSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => params}) do
    case Device.create(params) do
      {:ok, _device} ->
        conn
        |> redirect(to: Routes.device_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> Device.get()
    |> case do
      {:ok, device} ->
        changeset = DeviceSchema.changeset(device, %{})
        render(conn, "edit.html", changeset: changeset, device: device)

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.device_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> Device.get()
    |> case do
      {:ok, device} ->
        device = Repo.preload(device, sensors: :sensor_type)
        render(conn, "show.html", device: device)

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.device_path(conn, :index))
    end
  end

  def update(conn, %{"device" => params, "id" => id}) do
    id = String.to_integer(id)
    {:ok, device} = Device.get(id)

    case Device.update(device, params) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Record updated!")
        |> redirect(to: Routes.device_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash("error", "There are some errors!")
        |> render("edit.html", changeset: changeset, device: device)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> Device.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.device_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.device_path(conn, :index))
    end
  end
end
