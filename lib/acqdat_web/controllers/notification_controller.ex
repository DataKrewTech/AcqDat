defmodule AcqdatWeb.NotificationController do
  use AcqdatWeb, :controller

  alias Acqdat.Model.{SensorNotification, Device}
  alias Acqdat.Schema.SensorNotifications, as: SN
  def index(conn, _) do
    notifications = SensorNotification.get_all()
    render(conn, "index.html", notifications: notifications)
  end

  def new(conn, _) do
    changeset = SN.changeset(%SN{}, %{})
    devices = Device.get_all()
    render(conn, "new.html", changeset: changeset, devices: devices)
  end

  def edit(conn, %{"id" => id}) do

  end

  def create(conn, params) do

  end

  def update(conn, params) do

  end

  def delete() do

  end
end
