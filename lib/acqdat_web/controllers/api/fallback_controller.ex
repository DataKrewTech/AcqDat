defmodule AcqdatWeb.API.FallBackController do
  use AcqdatWeb, :controller
  alias AcqdatWeb.ErrorView

  def call(conn, {:error, "not found"}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json-api", %{})
  end
end
