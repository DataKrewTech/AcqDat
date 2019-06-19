defmodule AcqdatWeb.NotificationController do
  use AcqdatWeb, :controller
  import Phoenix.View, only: [render_to_string: 3]
  alias Acqdat.Model.{SensorNotification, Device, Sensor}
  alias Acqdat.Schema.SensorNotifications, as: SN
  alias AcqdatWeb.NotificationView
  alias Acqdat.Repo
  def index(conn, _) do
    notifications = SensorNotification.get_all()
    render(conn, "index.html", notifications: notifications)
  end
  def new(conn, _) do
    changeset = SN.changeset(%SN{}, %{})
    devices = Device.get_all()
    render(conn, "new.html", changeset: changeset, devices: devices)
  end
  def create(conn, %{"notification" => params}) do
    with {:ok, _notification} <- SensorNotification.create(params) do
      redirect(conn, to: "/notifications")
    else
      {:error, changeset} ->
        devices = Device.get_all()
        conn
        |> put_flash(:error, "Some error occured !")
        |> render("new.html", changeset: changeset, devices: devices)
    end
  end
  def edit(conn, %{"id" => id}) do
    with {:ok, notification} <- SensorNotification.get(String.to_integer(id)) do
      changeset = SN.update_changeset(notification, %{})
      policies = SensorNotification.get_policies()
      render(conn, "edit.html", changeset: changeset, notification: notification, policies: policies)
    else
      {:error, message} ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: "/notifications")
    end
  end
  def update(conn, %{"id" => id, "notification" => params}) do
    {:ok, notification} = id |> String.to_integer() |> SensorNotification.get()

    with {:ok, _notification} <- SensorNotification.update(notification, params) do
      conn
      |> put_flash(:info, "Notification updated !")
      |> redirect(to: Routes.notification_path(conn, :index))
    else
      {:error, changeset} ->
        policies = SensorNotification.get_policies()
        conn
        |> put_flash(:error, "Some error occured !")
        |> render("edit.html", changeset: changeset, notification: notification, policies: policies)
    end
  end
  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> SensorNotification.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.notification_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.notification_path(conn, :index))
    end
  end
  def sensor_rule_configurations(conn, %{"id" => sensor_id}) do
    sensor_id = String.to_integer(sensor_id)

    with {:ok, sensor} <- Sensor.get(sensor_id) do
      sensor = Repo.preload(sensor, :sensor_type)
      value_keys = sensor.sensor_type.value_keys
      policies = SensorNotification.get_policies()

      html =
        render_to_string(
          NotificationView,
          "_rule_configuration.html",
          value_keys: value_keys,
          policies: policies
        )

      conn |> put_status(200) |> json(%{html: html})
    else
      {:error, message} ->
        conn
        |> put_status(201)
        |> json(%{error: message})
    end
  end
  def policy_preferences(conn, %{"module" => module, "key" => key}) do
    preferences = SensorNotification.policy_preferences(module, %{})

    html =
      render_to_string(
        NotificationView,
        "policy_preferences.html",
        preferences: preferences,
        key: key,
        module: module
      )

    conn
    |> put_status(200)
    |> json(%{html: html})
  end
end
