defmodule AcqdatWeb.Router do
  use AcqdatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug(AcqdatWeb.AuthenticationPipe)
    plug(AcqdatWeb.CurrentUser)
    plug :put_user_token
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  scope "/", AcqdatWeb do
    pipe_through :browser

    resources("/session", SessionController, only: [:new, :create])
    get("/session/log-out", SessionController, :delete)
  end

  scope "/", AcqdatWeb do
    pipe_through :api

    post("/device/add-data", DeviceController, :insert_data)
  end

  scope "/", AcqdatWeb do
    pipe_through [:browser, :authentication]

    get "/", PageController, :index
    resources("/sensor_types", SensorTypeController)
    resources("/devices", DeviceController) do
      resources("/sensors", SensorController)
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AcqdatWeb do
  #   pipe_through :api
  # end
end
