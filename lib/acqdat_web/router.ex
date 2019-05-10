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
  end

  # Other scopes may use custom stacks.
  # scope "/api", AcqdatWeb do
  #   pipe_through :api
  # end
end
