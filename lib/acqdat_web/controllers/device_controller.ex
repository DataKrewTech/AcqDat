defmodule AcqdatWeb.DeviceController do
  use AcqdatWeb, :controller

  def insert_data(conn, params) do
    conn
    |> put_status(200)
    |> render("success.json", message: "success")
  end

  def index(conn, _params) do

  end

  def new(conn, _params) do

  end

  def edit(conn, %{"id" => id}) do

  end

  def show(conn, %{"id" => id}) do

  end

  def update(conn, %{"device" => params, "id" => id}) do

  end

  def delete(conn, %{"id" => id}) do

  end

end
