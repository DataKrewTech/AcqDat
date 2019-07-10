defmodule AcqdatWeb.API.ErrorHandler do
  use AcqdatWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> render(AcqdatWeb.API.TokenView, "401.json", message: to_string(type))
  end
end
