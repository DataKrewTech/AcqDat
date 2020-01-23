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
    plug :accepts, ["json", "json-api"]
  end

  pipeline :api_bearer_auth do
    plug AcqdatWeb.API.BearerAuthPipeline
  end

  pipeline :api_ensure_auth do
    plug AcqdatWeb.API.EnsureAuthPipeline
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
    get("/sensor-data/:id/", SensorController, :sensor_data)
  end

  scope "/", AcqdatWeb do
    pipe_through [:browser, :authentication]

    get "/", PageController, :index
    resources("/sensor_types", SensorTypeController)

    resources("/devices", DeviceController) do
      resources("/sensors", SensorController)
    end

    resources("/notifications", NotificationController)

    get "/device-sensors/:id", SensorController, :device_sensors
    get "/notification-configuration/:id", NotificationController, :sensor_rule_configurations
    post "/notification/rule_preferences", NotificationController, :policy_preferences
    resources("/data-trace", DataTraceController, only: [:index, :show])
    resources("/energy-management", EnergyManagementController, only: [:index])

    # Process Data History
    scope "/process-data-history", ProcessDataHistory do
      get "/dryer", DryerController, :data_history
      get "/wet-pre-breaker", WetPreBreakerController, :data_history
      get "/ipal-water-inlet", IpalWaterInletController, :data_history
    end

    # Tool Management
    scope "/tool-management", ToolManagement do
      get("/dashboard", DashboardController, :show)
      resources("/employee", EmployeeController)
      resources("/tool-box", ToolBoxController) do
        resources("/tools", ToolController)
      end
      resources("/tool-type", ToolTypeController, except: [:show])
    end

  end

  scope "/api", AcqdatWeb.API do
    pipe_through [:api]

    post "/token", TokenController, :create

  end

  scope "/api", AcqdatWeb.API do
    pipe_through [:api, :api_bearer_auth, :api_ensure_auth]

    get "/devices", DeviceController, :index
    get "/devices/:id/show", DeviceController, :show
    post "/sensor/:id/data", SensorController, :data
    post("/tl-mgmt/employee/identify", ToolManagementController, :verify_employee)
    post("/tl-mgmt/tool-transaction", ToolManagementController, :tool_transaction)
    post("/tl-mgmt/employees", ToolManagementController, :list_employees)
    post("/tl-mgmt/verify-tool", ToolManagementController, :verify_tool)
    post("/tl-mgmt/employee-tool-issue-status", ToolManagementController,
      :employee_tool_issue_status)
    post("/tl-mgmt/tool-box-status", ToolManagementController,
      :tool_box_status)

  end

  # Other scopes may use custom stacks.
  # scope "/api", AcqdatWeb do
  #   pipe_through :api
  # end
end
