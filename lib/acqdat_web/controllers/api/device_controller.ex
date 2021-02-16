defmodule AcqdatWeb.API.DeviceController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.Device
  alias Acqdat.Repo

  action_fallback(AcqdatWeb.API.FallBackController)

  def index(conn, _params) do
    devices = Device.get_all()
    render(conn, "index.json-api", data: devices)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, device} <- id |> String.to_integer() |> Device.get() do
      device = device |> Repo.preload(:sensors)
      render(conn, "show.json-api", data: device, opts: [include: "sensors"])
    end
  end

  def latest_data(conn, %{"device_id" => device_uuid}) do
    data = Device.get_latest_data(device_uuid)
    render(conn, "latest-data.json-api", data: data)
  end
end
