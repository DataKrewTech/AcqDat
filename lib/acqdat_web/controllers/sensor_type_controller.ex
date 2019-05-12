defmodule AcqdatWeb.SensorTypeController do
  use AcqdatWeb, :controller

  alias Acqdat.Model.SensorType
  alias Acqdat.Schema.SensorType, as: SensorTypeSchema


  def index(conn, _params) do
    sensor_types = SensorType.get_all()
    render(conn, "index.html", sensor_types: sensor_types)
  end

  def create(conn, %{"sensor_type" => params}) do
    case SensorType.create(params) do
      {:ok, _sensor_type} ->
        conn
        |> redirect(to: Routes.sensor_type_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = SensorTypeSchema.changeset(%SensorTypeSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> SensorType.get()
    |> case do
      {:ok, sensor_type} ->
        changeset = SensorTypeSchema.changeset(sensor_type, %{})
        render(conn, "edit.html", changeset: changeset, sensor_type: sensor_type)
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.sensor_type_path(conn, :index))
    end
  end

  def update(conn, %{"sensor_type" => params, "id" => id}) do
    id = String.to_integer(id)
    {:ok, sensor_type} = SensorType.get(id)

    case SensorType.update(sensor_type, params) do
      {:ok, _sensor_type} ->
        conn
        |> put_flash(:info, "Record updated!")
        |> redirect(to: Routes.sensor_type_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash("error", "There are some errors!")
        |> render("edit.html", changeset: changeset, sensor_type: sensor_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> SensorType.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.sensor_type_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Some errro occured!")
        |> redirect(to: Routes.sensor_type_path(conn, :index))
    end
  end
end
