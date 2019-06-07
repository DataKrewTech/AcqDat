defmodule AcqdatWeb.NotificationController do
  use AcqdatWeb, :controller

  alias Acqdat.Model.SensorNotification
  def index(conn, _) do
    notifications = SensorNotification.get_all()
    render(conn, "index.html", notifications: notifications)
  end

  def new(conn, _) do
    render(conn, "new.html")
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
