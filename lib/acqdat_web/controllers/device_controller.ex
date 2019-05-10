defmodule AcqdatWeb.DeviceController do
  use AcqdatWeb, :controller

  def insert_data(conn, params) do
    conn
    |> put_status(200)
    |> render("success.json", message: "success")
  end

end
